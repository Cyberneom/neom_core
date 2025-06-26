import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;

import '../../../app_config.dart';
import '../../../app_properties.dart';
import '../../../domain/model/stripe/stripe_price.dart';
import '../../../domain/model/stripe/stripe_product.dart';
import '../../../domain/model/stripe/stripe_session.dart';

class StripeService {


  static Future<StripeCheckoutSession> createCheckoutSessionUrl(String email, String priceId, {bool isDebug = false, int trialPeriodDays = 0}) async {

    String url = 'https://api.stripe.com/v1/checkout/sessions';
    StripeCheckoutSession checkoutSession = StripeCheckoutSession();

    try {

      Map<String, String> body = {
        'payment_method_types[]': 'card',
        'mode': 'subscription',
        'customer_email': email,
        'line_items[0][price]': priceId,
        'line_items[0][quantity]': '1',
        'success_url': 'https://www.escritoresmxi.org/suscripcion-confirmada',
        'cancel_url': 'https://www.escritoresmxi.org/suscripcion-fallida',
      };

      if(trialPeriodDays > 0) {
        body['subscription_data[trial_period_days]'] = trialPeriodDays.toString();
      }
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AppProperties.getStripeSecretKey()}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        AppConfig.logger.i('Checkout session created: ${responseData['id']}');
        checkoutSession.id = responseData['id'];
        checkoutSession.url= responseData['url'];
      } else {
        AppConfig.logger.w('Error: ${responseData['error']['message']}');
      }
    } catch (e) {
      AppConfig.logger.e('Error creating checkout session: $e');
    }

    return checkoutSession;
  }

  // static Future<void> createSubscription({required String email, required String paymentMethodId,}) async {
  //   try {
  //   } catch (e) {
  //     AppConfig.logger.d('Error creating subscription: $e');
  //   }
  // }

  static Future<String> getSubscriptionId(String sessionId, {bool? isDebug}) async {
    AppConfig.logger.d('getSubscriptionId by sessionId: $sessionId');

    String url = 'https://api.stripe.com/v1/checkout/sessions/$sessionId';
    String subscriptionId = '';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${AppProperties.getStripeSecretKey(isDebug: isDebug)}',
      },
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      subscriptionId = responseData['subscription'] ?? '';
      if (subscriptionId.isNotEmpty) {
        AppConfig.logger.i('Subscription ID: $subscriptionId');
        // Aquí puedes guardar el subscriptionId o hacer algo con él
      } else {
        AppConfig.logger.w('No subscription found for this session.');
      }
    } else {
      AppConfig.logger.e('Error fetching session: ${responseData['error']['message']}');
    }

    return subscriptionId;
  }

  static Future<String> getCustomerId(String sessionId) async {
    String url = 'https://api.stripe.com/v1/checkout/sessions/$sessionId';
    String customerId = '';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${AppProperties.getStripeSecretKey()}',
      },
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      customerId = responseData['customer'] ?? '';
      if (customerId.isNotEmpty) {
        AppConfig.logger.i('Customer ID: $customerId');
        // Aquí puedes guardar el subscriptionId o hacer algo con él
      } else {
        AppConfig.logger.w('No subscription found for this session.');
      }
    } else {
      AppConfig.logger.e('Error fetching session: ${responseData['error']['message']}');
    }

    return customerId;
  }

  static Future<bool> cancelSubscription(String subscriptionId, {bool? isDebug}) async {
    String url = 'https://api.stripe.com/v1/subscriptions/$subscriptionId';

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${AppProperties.getStripeSecretKey(isDebug: isDebug)}',
      },
    );

    if (response.statusCode == 200) {
      AppConfig.logger.i('Subscription cancelled successfully.');
      return true;
    } else {
      AppConfig.logger.e('Error cancelling subscription: ${json.decode(response.body)['error']['message']}');
    }

    return false;
  }

  static Future<void> getSubscriptionDetails(String subscriptionId) async {
    String url = 'https://api.stripe.com/v1/subscriptions/$subscriptionId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${AppProperties.getStripeSecretKey()}',
      },
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      AppConfig.logger.d('Subscription status: ${responseData['status']}');
      // Puedes manejar los diferentes estados, como "active", "canceled", etc.
    } else {
      AppConfig.logger.d('Error fetching subscription details: ${responseData['error']['message']}');
    }
  }

  static Future<void> getCustomerIdByEmail(String email) async {
    String url = 'https://api.stripe.com/v1/customers?email=$email';  // Filtra por email

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${AppProperties.getStripeSecretKey()}',
      },
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      List customers = responseData['data'];
      if (customers.isNotEmpty) {
        String customerId = customers[0]['id'];  // Obtén el primer cliente que coincide
        AppConfig.logger.d('Customer ID: $customerId');
        // Ahora puedes usar el customerId para obtener las suscripciones
        await getSubscriptionsFromCustomer(customerId);
      } else {
        AppConfig.logger.d('No customer found with that email.');
      }
    } else {
      AppConfig.logger.d('Error fetching customer: ${responseData['error']['message']}');
    }
  }

  // Listar las suscripciones usando el Customer ID
  static Future<void> getSubscriptionsFromCustomer(String customerId) async {
    String url = 'https://api.stripe.com/v1/subscriptions?customer=$customerId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${AppProperties.getStripeSecretKey()}',
      },
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      List subscriptions = responseData['data'];
      if (subscriptions.isNotEmpty) {
        for (var subscription in subscriptions) {
          String subscriptionId = subscription['id'];
          AppConfig.logger.d('Subscription ID: $subscriptionId');
          AppConfig.logger.d('Status: ${subscription['status']}');
          // Aquí puedes manejar el subscriptionId o guardarlo en tu base de datos
        }
      } else {
        AppConfig.logger.d('No subscriptions found for this customer.');
      }
    } else {
      AppConfig.logger.d('Error fetching subscriptions: ${responseData['error']['message']}');
    }
  }

  static Future<List<StripeProduct>> getProducts({bool isDebug = false}) async {
    String url = 'https://api.stripe.com/v1/products';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AppProperties.getStripeSecretKey()}',
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        List productsData = responseData['data'];
        List<StripeProduct> products = productsData
            .map<StripeProduct>((productData) => StripeProduct.fromJSON(productData))
            .toList();

        AppConfig.logger.d('Products fetched successfully.');
        return products;
      } else {
        AppConfig.logger.e('Error fetching products: ${responseData['error']['message']}');
        return [];
      }
    } catch (e) {
      AppConfig.logger.e('Error fetching products: $e');
      return [];
    }
  }

  static Future<StripeProduct?> getProductById(String productId, {bool isDebug = false}) async {
    String url = 'https://api.stripe.com/v1/products/$productId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AppProperties.getStripeSecretKey()}',
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        StripeProduct product = StripeProduct.fromJSON(responseData);
        AppConfig.logger.d('Product fetched: $productId');
        return product;
      } else {
        AppConfig.logger.e('Error fetching product: ${responseData['error']['message']}');
        return null;
      }
    } catch (e) {
      AppConfig.logger.e('Error fetching product: $e');
      return null;
    }
  }

  static Future<StripePrice?> getPrice(String priceId, {bool isDebug = false}) async {
    String url = 'https://api.stripe.com/v1/prices/$priceId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AppProperties.getStripeSecretKey()}',
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        // Convertir los datos del precio desde JSON al modelo StripePrice
        StripePrice price = StripePrice.fromJSON(responseData);
        AppConfig.logger.d('Price fetched successfully: $priceId');
        return price;
      } else {
        AppConfig.logger.e('Error fetching price: ${responseData['error']['message']}');
        return null;
      }
    } catch (e) {
      AppConfig.logger.e('Error fetching price: $e');
      return null;
    }
  }


  static Future<List<StripePrice>> getProductPrices(String productId, {bool isDebug = false}) async {
    String url = 'https://api.stripe.com/v1/prices?product=$productId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AppProperties.getStripeSecretKey()}',
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        List pricesData = responseData['data'];
        List<StripePrice> prices = pricesData
            .map<StripePrice>((priceData) => StripePrice.fromJSON(priceData))
            .toList();

        AppConfig.logger.d('Prices fetched for product: $productId');
        return prices;
      } else {
        AppConfig.logger.e('Error fetching prices: ${responseData['error']['message']}');
        return [];
      }
    } catch (e) {
      AppConfig.logger.e('Error fetching prices: $e');
      return [];
    }
  }

  static Future<Map<String, List<StripePrice>>> getRecurringPricesFromStripe() async {
    AppConfig.logger.d('getRecurringPricesFromStripe');
    Map<String, List<StripePrice>> recurringProductPrices = {};

    try {
      // Fetch products from Stripe
      List<StripeProduct> products = await StripeService.getProducts();


      for (StripeProduct product in products) {
        // Fetch prices for each product
        List<StripePrice> prices = await StripeService.getProductPrices(product.id);

        // Filter only recurring prices
        List<StripePrice> recurringPrices = prices
            .map((price) => price)
            .where((price) => price.interval != null).toList();

        if (recurringPrices.isNotEmpty) {
          // Store product info and recurring prices
          recurringProductPrices[product.id] = prices;
        }
      }

      AppConfig.logger.d("Fetched Stripe Subscription Products & Prices successfully");
      return recurringProductPrices;
    } catch (e) {
      AppConfig.logger.e("Error fetching recurring prices: $e");
    }

    return recurringProductPrices;
  }


}
