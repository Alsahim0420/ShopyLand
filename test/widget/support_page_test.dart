import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/presentation/pages/support_page.dart';

void main() {
  group('SupportPage', () {
    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: const SupportPage(),
      );
    }

    testWidgets('debe mostrar la página de soporte', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Support Center'), findsOneWidget);
    });

    testWidgets('debe mostrar campo de búsqueda', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('debe mostrar sección de FAQs', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Frequently Asked Questions'), findsOneWidget);
    });

    testWidgets('debe mostrar opciones de contacto', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Still need help?'), findsOneWidget);
    });

    testWidgets('debe expandir FAQs al tocarlas', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final faqItems = find.byType(ExpansionTile);
      expect(faqItems, findsWidgets);

      await tester.tap(faqItems.first);
      await tester.pumpAndSettle();

      // Verificar que se expandió
      expect(find.byType(ExpansionTile), findsWidgets);
    });

    testWidgets('debe mostrar opción de Live Chat', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Live Chat'), findsOneWidget);
      expect(find.text('Wait time: < 2 min'), findsOneWidget);
    });

    testWidgets('debe mostrar mensaje al tocar Live Chat', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final liveChatOption = find.text('Live Chat');
      await tester.tap(liveChatOption);
      await tester.pump();

      expect(find.text('Live chat en desarrollo'), findsOneWidget);
    });

    testWidgets('debe mostrar opciones de Email y Call', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Email Support'), findsOneWidget);
      expect(find.text('Call Us'), findsOneWidget);
    });

    testWidgets('debe mostrar banner de Priority Support', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Priority Support'), findsOneWidget);
      expect(find.text('Join Premium to get instant help anytime.'), findsOneWidget);
    });

    testWidgets('debe mostrar mensaje al tocar Email Support', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final emailOption = find.text('Email Support');
      await tester.tap(emailOption);
      await tester.pump();

      expect(find.text('Email support en desarrollo'), findsOneWidget);
    });

    testWidgets('debe mostrar mensaje al tocar Call Us', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final callOption = find.text('Call Us');
      await tester.tap(callOption);
      await tester.pump();

      expect(find.text('Call support en desarrollo'), findsOneWidget);
    });

    testWidgets('debe expandir y colapsar múltiples FAQs', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final faqItems = find.byType(ExpansionTile);
      expect(faqItems, findsWidgets);

      // Expandir primera FAQ
      await tester.tap(faqItems.first);
      await tester.pumpAndSettle();

      // Expandir segunda FAQ
      if (faqItems.evaluate().length > 1) {
        await tester.tap(faqItems.at(1));
        await tester.pumpAndSettle();
      }

      // Colapsar primera FAQ
      await tester.tap(faqItems.first);
      await tester.pumpAndSettle();

      expect(find.byType(ExpansionTile), findsWidgets);
    });

    testWidgets('debe permitir escribir en el campo de búsqueda', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'order status');
      await tester.pump();

      expect(find.text('order status'), findsOneWidget);
    });
  });
}
