import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_stripe/flutter_stripe.dart';

import '../config/api_config.dart';

enum StripePaymentStatus { success, cancelled, failed }

class StripePaymentOutcome {
  final StripePaymentStatus status;
  final String message;
  final Map<String, dynamic>? paymentResponse;

  const StripePaymentOutcome({
    required this.status,
    required this.message,
    this.paymentResponse,
  });

  bool get isSuccess => status == StripePaymentStatus.success;
}

/// Handles Stripe Payment Sheet via [flutter_stripe].
///
/// PaymentIntents are created against Stripe's API with the secret key from
/// `.env` until the backend exposes a create-intent endpoint. Move that step
/// server-side before production.
class StripePaymentService {
  StripePaymentService._();
  static final StripePaymentService instance = StripePaymentService._();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.stripe.com/v1/',
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    ),
  );

  Future<StripePaymentOutcome> pay({
    required double amount,
    required String bookingId,
    String currency = 'cad',
  }) async {
    if (ApiConfig.stripePublishableKey.isEmpty ||
        ApiConfig.stripePublishableKey.contains('REPLACE_ME')) {
      return const StripePaymentOutcome(
        status: StripePaymentStatus.failed,
        message:
            'Stripe publishable key is missing. Set STRIPE_PUBLISHABLE_KEY in .env.',
      );
    }

    if (ApiConfig.stripeSecretKey.isEmpty ||
        ApiConfig.stripeSecretKey.contains('REPLACE_ME')) {
      return const StripePaymentOutcome(
        status: StripePaymentStatus.failed,
        message:
            'Stripe secret key is missing. Set STRIPE_SECRET_KEY in .env (temporary until backend create-intent is ready).',
      );
    }

    String? clientSecret;

    try {
      final paymentIntent = await _createPaymentIntent(
        amount: amount,
        currency: currency,
        bookingId: bookingId,
      );

      clientSecret = paymentIntent['client_secret'] as String?;
      if (clientSecret == null || clientSecret.isEmpty) {
        return const StripePaymentOutcome(
          status: StripePaymentStatus.failed,
          message: 'Stripe did not return a client secret.',
        );
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Tap On Task',
          style: ThemeMode.system,
          billingDetailsCollectionConfiguration:
              const BillingDetailsCollectionConfiguration(
            name: CollectionMode.automatic,
            email: CollectionMode.automatic,
            phone: CollectionMode.automatic,
            address: AddressCollectionMode.automatic,
          ),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'CA',
            currencyCode: 'CAD',
            testEnv: true,
          ),
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'CA',
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      final confirmed = await Stripe.instance.retrievePaymentIntent(clientSecret);
      final responseJson = <String, dynamic>{
        ...paymentIntent,
        ...confirmed.toJson(),
        'status': confirmed.status.name,
      };

      final prettyJson = const JsonEncoder.withIndent('  ').convert(responseJson);
      developer.log(
        '\n========== STRIPE PAYMENT RESPONSE ==========\n'
        '$prettyJson\n'
        '=============================================',
        name: 'StripePayment',
      );
      // ignore: avoid_print
      print('STRIPE_PAYMENT_RESPONSE_JSON=$prettyJson');

      return StripePaymentOutcome(
        status: StripePaymentStatus.success,
        message: 'Payment successful',
        paymentResponse: responseJson,
      );
    } on StripeException catch (e) {
      final code = e.error.code;
      final cancelled = code == FailureCode.Canceled;

      developer.log(
        'StripeException: code=$code message=${e.error.localizedMessage}',
        name: 'StripePayment',
      );

      return StripePaymentOutcome(
        status: cancelled
            ? StripePaymentStatus.cancelled
            : StripePaymentStatus.failed,
        message: cancelled
            ? 'Payment cancelled'
            : (e.error.localizedMessage ?? 'Payment failed'),
      );
    } on DioException catch (e) {
      final message = _stripeApiErrorMessage(e);
      developer.log('Stripe API error: $message', name: 'StripePayment');
      return StripePaymentOutcome(
        status: StripePaymentStatus.failed,
        message: message,
      );
    } catch (e) {
      developer.log('Payment error: $e', name: 'StripePayment');
      return StripePaymentOutcome(
        status: StripePaymentStatus.failed,
        message: e.toString(),
      );
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent({
    required double amount,
    required String currency,
    required String bookingId,
  }) async {
    final amountInCents = (amount * 100).round();

    final response = await _dio.post(
      'payment_intents',
      data: {
        'amount': amountInCents.toString(),
        'currency': currency.toLowerCase(),
        'payment_method_types[]': 'card',
        'metadata[booking_id]': bookingId,
        'metadata[source]': 'tap_on_task_mobile',
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${ApiConfig.stripeSecretKey}',
        },
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw Exception('Unexpected PaymentIntent response from Stripe.');
  }

  String _stripeApiErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final error = data['error'];
      if (error is Map && error['message'] is String) {
        return error['message'] as String;
      }
    }
    return e.message ?? 'Failed to create Stripe PaymentIntent.';
  }
}
