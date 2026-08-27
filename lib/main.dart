import 'package:flutter/material.dart';

void main() => runApp(const YallaGoApp());

class AppColors {
  static const nile = Color(0xFF006E90);
  static const nileDark = Color(0xFF004E68);
  static const hibiscus = Color(0xFFE84757);
  static const papyrus = Color(0xFFF7F4ED);
  static const paper = Color(0xFFFFFDFA);
  static const ink = Color(0xFF172B35);
  static const mist = Color(0xFFE7F3F6);
  static const green = Color(0xFF188A68);
  static const line = Color(0xFFE4E0D7);
}

class YallaGoApp extends StatefulWidget {
  const YallaGoApp({super.key});

  @override
  State<YallaGoApp> createState() => _YallaGoAppState();
}

class _YallaGoAppState extends State<YallaGoApp> {
  bool _arabic = true;
  int _cartCount = 2;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.papyrus,
      fontFamily: 'sans-serif',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.nile,
        primary: AppColors.nile,
        secondary: AppColors.hibiscus,
        surface: AppColors.paper,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: AppColors.papyrus,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.paper,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.nile, width: 1.5),
        ),
      ),
    );

    return YallaScope(
      arabic: _arabic,
      cartCount: _cartCount,
      toggleLanguage: () => setState(() => _arabic = !_arabic),
      updateCart: (value) => setState(() => _cartCount = value.clamp(0, 99)),
      child: MaterialApp(
        title: 'YallaGo',
        debugShowCheckedModeBanner: false,
        theme: theme,
        builder: (context, child) => Directionality(
          textDirection: _arabic ? TextDirection.rtl : TextDirection.ltr,
          child: child ?? const SizedBox.shrink(),
        ),
        home: const VendorMenuScreen(),
      ),
    );
  }
}

class YallaScope extends InheritedWidget {
  const YallaScope({
    required this.arabic,
    required this.cartCount,
    required this.toggleLanguage,
    required this.updateCart,
    required super.child,
    super.key,
  });

  final bool arabic;
  final int cartCount;
  final VoidCallback toggleLanguage;
  final ValueChanged<int> updateCart;

  static YallaScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<YallaScope>()!;

  @override
  bool updateShouldNotify(YallaScope oldWidget) =>
      arabic != oldWidget.arabic || cartCount != oldWidget.cartCount;
}

String tr(BuildContext context, String ar, String en) =>
    YallaScope.of(context).arabic ? ar : en;

void go(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
}

const _pagePadding = EdgeInsets.fromLTRB(20, 12, 20, 24);

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const customer = true;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              top: 52,
              right: -60,
              child: _RouteArc(size: 230, color: Colors.white24),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: LanguageButton(
                        onTap: YallaScope.of(context).toggleLanguage),
                  ),
                  const Spacer(),
                  Center(
                    child: Container(
                      width: 138,
                      height: 138,
                      padding: const EdgeInsets.all(21),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(38),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 24,
                              offset: Offset(0, 12))
                        ],
                      ),
                      child: Image.asset(
                          'assets/images/yallago-customer-icon.png'),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    tr(context, 'يلا جوّ وصل', 'Your cravings, on the way'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        height: 1.12),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tr(context, 'أكل الحتة اللي بتحبها، من غير لف كتير.',
                        'The neighborhood food you love, without the detour.'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const Spacer(),
                  _RoleSelector(customer: customer),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: () =>
                        go(context, const AuthScreen(customer: true)),
                    icon: const Icon(Icons.arrow_back),
                    label: Text(tr(context, 'يلا نبدأ', 'Start ordering')),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.nileDark,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('CAIRO · EGYPT · MVP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          letterSpacing: 1.2)),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.nile,
    );
  }
}

class _RoleSelector extends StatefulWidget {
  const _RoleSelector({required this.customer});
  final bool customer;

  @override
  State<_RoleSelector> createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<_RoleSelector> {
  late bool customer = widget.customer;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24)),
        child: Row(
          children: [
            Expanded(
                child: _RoleChip(
                    label: tr(context, 'تطبيق العميل', 'Customer app'),
                    active: customer,
                    onTap: () => setState(() => customer = true))),
            const SizedBox(width: 5),
            Expanded(
                child: _RoleChip(
                    label: tr(context, 'تطبيق المطعم', 'Vendor app'),
                    active: !customer,
                    onTap: () {
                      setState(() => customer = false);
                      go(context, const AuthScreen(customer: false));
                    })),
          ],
        ),
      );
}

class _RoleChip extends StatelessWidget {
  const _RoleChip(
      {required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
              color: active ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(12)),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: active ? AppColors.nileDark : Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12)),
        ),
      );
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({required this.customer, super.key});
  final bool customer;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool codeSent = false;
  final phone = TextEditingController(text: '010 1234 5678');

  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vendor = !widget.customer;
    return Scaffold(
      appBar: AppBar(actions: [
        LanguageButton(onTap: YallaScope.of(context).toggleLanguage)
      ]),
      body: SafeArea(
        child: ListView(
          padding: _pagePadding,
          children: [
            Center(
                child: Image.asset(
                    vendor
                        ? 'assets/images/logo.PNG'
                        : 'assets/images/yallago-customer-icon.png',
                    width: 88,
                    height: 88)),
            const SizedBox(height: 24),
            Text(
                tr(
                    context,
                    vendor ? 'خلّي مطعمك ماشي بسرعة' : 'أهلاً بيك في يلا جو',
                    vendor ? 'Keep your kitchen moving' : 'Welcome to YallaGo'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 27, fontWeight: FontWeight.w800, height: 1.2)),
            const SizedBox(height: 8),
            Text(
              tr(
                context,
                vendor
                    ? 'ادخل برقم الموبايل لإدارة المنيو والطلبات.'
                    : 'ادخل برقم موبايلك وهنبعتلك كود تأكيد.',
                vendor
                    ? 'Enter your mobile number to manage the menu and orders.'
                    : 'Enter your mobile number and we’ll send you a verification code.',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            Text(
                tr(
                  context,
                  vendor
                      ? 'ادخل برقم الموبايل لإدارة المنيو والطلبات.'
                      : 'ادخل برقم موبايلك وهنبعتلك كود تأكيد.',
                  vendor
                      ? 'Enter your mobile number to manage the menu and orders.'
                      : 'Enter your mobile number and we will send you a verification code.',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, height: 1.5)),
            const SizedBox(height: 30),
            if (!codeSent) ...[
              Text(tr(context, 'رقم الموبايل', 'Mobile number'),
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              TextField(
                  keyboardType: TextInputType.phone,
                  controller: phone,
                  textDirection: TextDirection.ltr,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone_outlined),
                      prefixText: '+20  ')),
              const SizedBox(height: 18),
              PrimaryButton(
                  label: tr(context, 'ابعت الكود', 'Send code'),
                  icon: Icons.sms_outlined,
                  onTap: () => setState(() => codeSent = true)),
            ] else ...[
              Text(tr(context, 'اكتب كود التأكيد', 'Enter verification code'),
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: TextDirection.ltr,
                  children:
                      List.generate(4, (index) => const _OtpBox(value: '•'))),
              const SizedBox(height: 20),
              PrimaryButton(
                  label: tr(context, 'تأكيد والدخول', 'Verify & continue'),
                  icon: Icons.verified_outlined,
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => vendor
                                ? const VendorMenuScreen()
                                : const CustomerHomeScreen()),
                        (route) => false);
                  }),
              TextButton(
                  onPressed: () => setState(() => codeSent = false),
                  child: Text(tr(context, 'غيّر الرقم', 'Change number'))),
            ],
            const SizedBox(height: 22),
            Text(
                tr(
                    context,
                    'نموذج MVP: التحقق محاكى محليًا. اربط واجهة OTP الحقيقية لاحقًا مع POST /auth/send-otp و POST /auth/verify-otp.',
                    'MVP prototype: OTP is locally simulated. Replace it with POST /auth/send-otp and POST /auth/verify-otp.'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black45, fontSize: 11, height: 1.55)),
          ],
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({required this.value});
  final String value;
  @override
  Widget build(BuildContext context) => Container(
        width: 62,
        height: 58,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.paper,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.line)),
        child: Text(value,
            style: const TextStyle(
                fontSize: 28,
                color: AppColors.nile,
                fontWeight: FontWeight.w800)),
      );
}

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.notifications_none_rounded)),
          actions: [
            IconButton(
                onPressed: () => go(context, const OrderHistoryScreen()),
                icon: const Icon(Icons.receipt_long_outlined)),
          ],
          title: Column(children: [
            Text(tr(context, 'وصل عند', 'Deliver to'),
                style: const TextStyle(fontSize: 11)),
            Text(tr(context, 'المعادي، القاهرة', 'Maadi, Cairo'),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w800))
          ]),
        ),
        body: ListView(
          padding: _pagePadding,
          children: [
            Text(tr(context, 'إيه نفسك فيه دلوقتي؟', 'What are you craving?'),
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w800, height: 1.15)),
            const SizedBox(height: 15),
            TextField(
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: const Icon(Icons.tune),
                    hintText: tr(context, 'دور على مطعم أو أكلة',
                        'Search restaurants or dishes'))),
            const SizedBox(height: 14),
            const _FilterRow(),
            const SizedBox(height: 17),
            const PromoBanner(),
            const SizedBox(height: 20),
            SectionTitle(
                title: tr(context, 'اختار مزاجك', 'Pick your mood'),
                action: tr(context, 'عرض الكل', 'See all')),
            const SizedBox(height: 10),
            SizedBox(
                height: 118,
                child:
                    ListView(scrollDirection: Axis.horizontal, children: const [
                  CategoryCard(
                      labelAr: 'فطار',
                      labelEn: 'Breakfast',
                      asset: 'assets/images/yallago-bakery.jpg'),
                  CategoryCard(
                      labelAr: 'كشري',
                      labelEn: 'Koshary',
                      asset: 'assets/images/yallago-koshary.jpg'),
                  CategoryCard(
                      labelAr: 'مشويات',
                      labelEn: 'Grills',
                      asset: 'assets/images/yallago-grill.jpg'),
                  CategoryCard(
                      labelAr: 'حلويات',
                      labelEn: 'Dessert',
                      asset: 'assets/images/yallago-bakery.jpg')
                ])),
            const SizedBox(height: 20),
            SectionTitle(
                title: tr(context, 'مطاعم قريبة منك', 'Close to you'),
                action: tr(context, 'شوف الكل', 'View all')),
            const RouteRibbon(),
            RestaurantCard(
                onTap: () => go(context, const RestaurantScreen()),
                nameAr: 'مشويات الحارة',
                nameEn: 'El Hara Grill',
                asset: 'assets/images/yallago-grill.jpg',
                ticketAr: 'فحم وسخن',
                ticketEn: 'Charcoal hot',
                time: tr(context, '٣٥–٤٥ دقيقة', '35–45 min'),
                rating: '4.8'),
            const SizedBox(height: 10),
            RestaurantCard(
                onTap: () => go(context, const RestaurantScreen()),
                nameAr: 'كشري على أصوله',
                nameEn: 'Koshary Aslo',
                asset: 'assets/images/yallago-koshary.jpg',
                ticketAr: 'سريع وقريب',
                ticketEn: 'Quick nearby',
                time: tr(context, '٢٥–٣٥ دقيقة', '25–35 min'),
                rating: '4.7'),
            const SizedBox(height: 94),
          ],
        ),
        bottomNavigationBar: const CustomerNav(index: 0),
        floatingActionButton:
            CartDock(onTap: () => go(context, const CartScreen())),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
}

class _FilterRow extends StatelessWidget {
  const _FilterRow();
  @override
  Widget build(BuildContext context) => SizedBox(
        height: 38,
        child: ListView(scrollDirection: Axis.horizontal, children: [
          FilterChipWidget(label: tr(context, 'الكل', 'All'), active: true),
          FilterChipWidget(label: tr(context, 'يوصل بسرعة', 'Fast delivery')),
          FilterChipWidget(label: tr(context, 'تقييم عالي', 'Top rated')),
        ]),
      );
}

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: const BoxDecoration(
          gradient:
              LinearGradient(colors: [AppColors.nileDark, AppColors.nile]),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
              bottomLeft: Radius.circular(22),
              bottomRight: Radius.circular(4)),
        ),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                    tr(context, 'الطلب عليك.. التوصيل علينا',
                        'Your order. Delivery on us.'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        height: 1.25)),
                const SizedBox(height: 5),
                Text(
                    tr(context, 'على أول طلب من التطبيق',
                        'On your first app order'),
                    style: const TextStyle(color: Colors.white70, fontSize: 12))
              ])),
          Container(
              width: 62,
              height: 62,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: AppColors.hibiscus, shape: BoxShape.circle),
              child: const Text('-30%',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800))),
        ]),
      );
}

class CategoryCard extends StatelessWidget {
  const CategoryCard(
      {required this.labelAr,
      required this.labelEn,
      required this.asset,
      super.key});
  final String labelAr;
  final String labelEn;
  final String asset;
  @override
  Widget build(BuildContext context) => Container(
        width: 96,
        margin: const EdgeInsetsDirectional.only(end: 10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(5)),
            image:
                DecorationImage(image: AssetImage(asset), fit: BoxFit.cover)),
        child: Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Container(
                margin: const EdgeInsets.all(7),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(7)),
                child: Text(tr(context, labelAr, labelEn),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800)))),
      );
}

class RestaurantCard extends StatelessWidget {
  const RestaurantCard(
      {required this.onTap,
      required this.nameAr,
      required this.nameEn,
      required this.asset,
      required this.ticketAr,
      required this.ticketEn,
      required this.time,
      required this.rating,
      super.key});
  final VoidCallback onTap;
  final String nameAr;
  final String nameEn;
  final String asset;
  final String ticketAr;
  final String ticketEn;
  final String time;
  final String rating;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(19),
            topRight: Radius.circular(19),
            bottomLeft: Radius.circular(19),
            bottomRight: Radius.circular(5)),
        child: Ink(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: AppColors.paper,
              border: Border.all(color: AppColors.line),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(19),
                  topRight: Radius.circular(19),
                  bottomLeft: Radius.circular(19),
                  bottomRight: Radius.circular(5))),
          child: Row(children: [
            ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(13),
                    topRight: Radius.circular(13),
                    bottomLeft: Radius.circular(13),
                    bottomRight: Radius.circular(5)),
                child: Image.asset(asset,
                    width: 94, height: 90, fit: BoxFit.cover)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  TicketLabel(label: tr(context, ticketAr, ticketEn)),
                  const SizedBox(height: 4),
                  Text(tr(context, nameAr, nameEn),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text('★ $rating   ·   $time',
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.nileDark,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 5),
                  Text(tr(context, 'توصيل من ١٢ جنيه', 'Delivery from EGP 12'),
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 11)),
                ])),
          ]),
        ),
      );
}

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(slivers: [
          SliverAppBar(
            expandedHeight: 255,
            pinned: true,
            backgroundColor: AppColors.nileDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(fit: StackFit.expand, children: [
                Image.asset('assets/images/yallago-grill.jpg',
                    fit: BoxFit.cover),
                const DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black87]))),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  tr(context, 'مشويات الحارة', 'El Hara Grill'),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800)),
                              Text(
                                  tr(context, 'مشويات مصرية · المعادي',
                                      'Egyptian grill · Maadi'),
                                  style:
                                      const TextStyle(color: Colors.white70)),
                              const SizedBox(height: 8),
                              Text(
                                  '★ 4.8   ·   ${tr(context, '٣٥–٤٥ دقيقة', '35–45 min')}',
                                  textDirection: TextDirection.ltr,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700))
                            ]))),
              ]),
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
                  padding: _pagePadding,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _MenuTabs(),
                        const SizedBox(height: 20),
                        SectionTitle(
                            title: tr(context, 'الأكثر طلبًا', 'Most popular'),
                            action: tr(context, '+١٢ صنف', '+12 items')),
                        MenuItemRow(
                            titleAr: 'ميكس جريل الحارة',
                            titleEn: 'El Hara Mixed Grill',
                            detailAr: 'كفتة، شيش طاووق، وريش ضاني',
                            detailEn: 'Kofta, shish tawook & lamb ribs',
                            price: 210,
                            asset: 'assets/images/yallago-grill.jpg',
                            onTap: () => go(context, const MenuItemScreen())),
                        MenuItemRow(
                            titleAr: 'كفتة مشوية',
                            titleEn: 'Charcoal Kofta',
                            detailAr: '٦ قطع كفتة مع عيش وطحينة',
                            detailEn: '6 kofta pieces with bread & tahini',
                            price: 135,
                            asset: 'assets/images/yallago-grill.jpg',
                            onTap: () => go(context, const MenuItemScreen())),
                        MenuItemRow(
                            titleAr: 'طاجن مكرونة باللحمة',
                            titleEn: 'Pasta & Beef Casserole',
                            detailAr: 'صوص طماطم ووش جبنة',
                            detailEn: 'Tomato sauce, cheese top',
                            price: 155,
                            asset: 'assets/images/yallago-koshary.jpg',
                            onTap: () => go(context, const MenuItemScreen())),
                        const SizedBox(height: 92),
                      ]))),
        ]),
        floatingActionButton:
            CartDock(onTap: () => go(context, const CartScreen())),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
}

class _MenuTabs extends StatelessWidget {
  const _MenuTabs();
  @override
  Widget build(BuildContext context) => SizedBox(
      height: 40,
      child: ListView(scrollDirection: Axis.horizontal, children: [
        FilterChipWidget(
            label: tr(context, 'الأكثر طلبًا', 'Most popular'), active: true),
        FilterChipWidget(label: tr(context, 'مشويات', 'Grill')),
        FilterChipWidget(label: tr(context, 'طواجن', 'Casseroles')),
        FilterChipWidget(label: tr(context, 'إضافات', 'Sides'))
      ]));
}

class MenuItemRow extends StatelessWidget {
  const MenuItemRow(
      {required this.titleAr,
      required this.titleEn,
      required this.detailAr,
      required this.detailEn,
      required this.price,
      required this.asset,
      required this.onTap,
      super.key});
  final String titleAr;
  final String titleEn;
  final String detailAr;
  final String detailEn;
  final int price;
  final String asset;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child:
                  Image.asset(asset, width: 75, height: 75, fit: BoxFit.cover)),
          const SizedBox(width: 11),
          Expanded(
              child: InkWell(
                  onTap: onTap,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr(context, titleAr, titleEn),
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(tr(context, detailAr, detailEn),
                            style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                                height: 1.35)),
                        const SizedBox(height: 6),
                        Price(value: price)
                      ]))),
          IconButton(
              onPressed: () {
                YallaScope.of(context)
                    .updateCart(YallaScope.of(context).cartCount + 1);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text(tr(context, 'اتضاف للسلة', 'Added to cart'))));
              },
              style: IconButton.styleFrom(
                  backgroundColor: AppColors.nile,
                  foregroundColor: Colors.white),
              icon: const Icon(Icons.add)),
        ]),
      );
}

class MenuItemScreen extends StatefulWidget {
  const MenuItemScreen({super.key});
  @override
  State<MenuItemScreen> createState() => _MenuItemScreenState();
}

class _MenuItemScreenState extends State<MenuItemScreen> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(slivers: [
          SliverAppBar(
              expandedHeight: 290,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset('assets/images/yallago-grill.jpg',
                      fit: BoxFit.cover))),
          SliverToBoxAdapter(
              child: Container(
            margin: const EdgeInsets.only(top: -22),
            padding: _pagePadding,
            decoration: const BoxDecoration(
                color: AppColors.papyrus,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                          tr(context, 'ميكس جريل الحارة',
                              'El Hara Mixed Grill'),
                          style: const TextStyle(
                              fontSize: 27, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Text(
                          tr(
                              context,
                              'كفتة، شيش طاووق، وريش ضاني مع رز بسمتي وطحينة وسلطة بلدي.',
                              'Kofta, shish tawook and lamb ribs with basmati rice, tahini and baladi salad.'),
                          style: const TextStyle(
                              color: Colors.black54, height: 1.45))
                    ])),
                const Price(value: 210, size: 16)
              ]),
              const SizedBox(height: 25),
              SectionTitle(
                  title: tr(context, 'درجة التتبيلة', 'Spice level'),
                  action: tr(context, 'اختياري', 'Optional')),
              const SizedBox(height: 8),
              const _SpiceChoices(),
              const SizedBox(height: 22),
              Text(tr(context, 'تعليمات خاصة', 'Special instructions'),
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                      hintText:
                          tr(context, 'مثال: من غير بصل', 'e.g. no onions'))),
              const SizedBox(height: 22),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(tr(context, 'الكمية', 'Quantity'),
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                QuantityControl(
                    value: quantity,
                    onChanged: (value) => setState(() => quantity = value))
              ]),
              const SizedBox(height: 22),
              PrimaryButton(
                  critical: true,
                  icon: Icons.shopping_bag_outlined,
                  label: tr(context, 'أضف للسلة · ${210 * quantity} ج.م',
                      'Add to cart · EGP ${210 * quantity}'),
                  onTap: () {
                    YallaScope.of(context).updateCart(
                        YallaScope.of(context).cartCount + quantity);
                    go(context, const CartScreen());
                  }),
            ]),
          )),
        ]),
      );
}

class _SpiceChoices extends StatefulWidget {
  const _SpiceChoices();
  @override
  State<_SpiceChoices> createState() => _SpiceChoicesState();
}

class _SpiceChoicesState extends State<_SpiceChoices> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    final choices = [
      tr(context, 'عادي', 'Normal'),
      tr(context, 'متوسط', 'Medium'),
      tr(context, 'حار', 'Hot')
    ];
    return Wrap(
        spacing: 8,
        children: List.generate(
            choices.length,
            (index) => ChoiceChip(
                label: Text(choices[index]),
                selected: selected == index,
                selectedColor: AppColors.mist,
                onSelected: (_) => setState(() => selected = index))));
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) => DetailScaffold(
        title: tr(context, 'مراجعة الطلب', 'Review order'),
        child: ListView(padding: _pagePadding, children: [
          Text(tr(context, 'سلتك', 'Your cart'),
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          Text(tr(context, 'من مشويات الحارة', 'From El Hara Grill'),
              style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 20),
          const CartRow(
              titleAr: 'ميكس جريل الحارة',
              titleEn: 'El Hara Mixed Grill',
              detailAr: 'تتبيلة عادية',
              detailEn: 'Normal spice',
              price: 210,
              asset: 'assets/images/yallago-grill.jpg'),
          const SizedBox(height: 10),
          const CartRow(
              titleAr: 'عيش بلدي طازة',
              titleEn: 'Fresh Baladi Bread',
              detailAr: 'قطعة إضافية',
              detailEn: 'Extra piece',
              price: 28,
              asset: 'assets/images/yallago-bakery.jpg'),
          const SizedBox(height: 22),
          SectionTitle(title: tr(context, 'ملخص الدفع', 'Payment summary')),
          const SizedBox(height: 8),
          const PaymentSummary(),
          const SizedBox(height: 18),
          PrimaryButton(
              label: tr(context, 'كمّل للتأكيد', 'Continue to checkout'),
              icon: Icons.arrow_back,
              onTap: () => go(context, const CheckoutScreen())),
        ]),
      );
}

class CartRow extends StatefulWidget {
  const CartRow(
      {required this.titleAr,
      required this.titleEn,
      required this.detailAr,
      required this.detailEn,
      required this.price,
      required this.asset,
      super.key});
  final String titleAr;
  final String titleEn;
  final String detailAr;
  final String detailEn;
  final int price;
  final String asset;
  @override
  State<CartRow> createState() => _CartRowState();
}

class _CartRowState extends State<CartRow> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only(bottom: 12),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.line))),
        child: Row(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.asset(widget.asset,
                  width: 65, height: 65, fit: BoxFit.cover)),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(tr(context, widget.titleAr, widget.titleEn),
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(tr(context, widget.detailAr, widget.detailEn),
                    style:
                        const TextStyle(fontSize: 11, color: Colors.black54)),
                const SizedBox(height: 7),
                QuantityControl(
                    compact: true,
                    value: quantity,
                    onChanged: (value) {
                      setState(() => quantity = value);
                    })
              ])),
          Price(value: widget.price * quantity),
        ]),
      );
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});
  @override
  Widget build(BuildContext context) => DetailScaffold(
        title: tr(context, 'تأكيد الطلب', 'Checkout'),
        child: ListView(padding: _pagePadding, children: [
          Text(tr(context, 'تأكيد الطلب', 'Confirm order'),
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          Text(
              tr(context, 'راجع التفاصيل قبل ما نبلغ المطعم.',
                  'Review details before we notify the restaurant.'),
              style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 20),
          SectionTitle(
              title: tr(context, 'مكان التوصيل', 'Delivery address'),
              action: tr(context, 'تعديل', 'Edit')),
          const SizedBox(height: 8),
          InfoCard(
              icon: Icons.location_on_outlined,
              title: tr(context, 'البيت', 'Home'),
              body: tr(context, '١٤ شارع ٢٠٠، دجلة، المعادي، القاهرة',
                  '14 St. 200, Degla, Maadi, Cairo')),
          const SizedBox(height: 19),
          SectionTitle(title: tr(context, 'طريقة الدفع', 'Payment method')),
          const SizedBox(height: 8),
          InfoCard(
              icon: Icons.payments_outlined,
              title: tr(context, 'الدفع عند الاستلام', 'Cash on delivery'),
              body: tr(context, 'جهز المبلغ وقت وصول طلبك.',
                  'Have the amount ready when your order arrives.'),
              selected: true),
          const SizedBox(height: 19),
          SectionTitle(title: tr(context, 'تفاصيل الطلب', 'Order details')),
          const SizedBox(height: 8),
          const PaymentSummary(simple: true),
          const SizedBox(height: 18),
          PrimaryButton(
              critical: true,
              label: tr(context, 'أكد الطلب', 'Place order'),
              icon: Icons.check_circle_outline,
              onTap: () => go(context, const OrderTrackingScreen())),
        ]),
      );
}

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});
  @override
  Widget build(BuildContext context) => DetailScaffold(
        title: tr(context, 'طلب #YG-1048', 'Order #YG-1048'),
        child: ListView(padding: _pagePadding, children: [
          const TrackingHero(),
          const SizedBox(height: 22),
          SectionTitle(
              title: tr(context, 'متابعة الطلب', 'Order tracking'),
              action: 'LIVE'),
          const SizedBox(height: 8),
          TrackingStep(
              done: true,
              title: tr(context, 'تم قبول الطلب', 'Order accepted'),
              subtitle: tr(context, 'المطعم أكد طلبك.',
                  'The restaurant confirmed your order.')),
          TrackingStep(
              active: true,
              title: tr(context, 'جاري التحضير', 'Preparing'),
              subtitle: tr(context, 'بيجهزوه مخصوص ليك.',
                  'Your kitchen is preparing it.')),
          TrackingStep(
              title: tr(context, 'جاهز للاستلام', 'Ready'),
              subtitle: tr(context, 'هنبلغك أول ما يجهز.',
                  'We will notify you when it is ready.')),
          const SizedBox(height: 14),
          InfoCard(
              icon: Icons.restaurant_outlined,
              title: tr(context, 'مشويات الحارة', 'El Hara Grill'),
              body: tr(context, 'ميكس جريل الحارة ×١ · عيش بلدي ×١',
                  'Mixed Grill ×1 · Baladi bread ×1')),
          const SizedBox(height: 18),
          OutlinedButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
                  (route) => false),
              child: Text(tr(context, 'رجوع للرئيسية', 'Back to home'))),
        ]),
      );
}

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar:
            AppBar(title: Text(tr(context, 'سجل الطلبات', 'Order history'))),
        body: ListView(padding: _pagePadding, children: [
          Text(tr(context, 'طلباتك', 'Your orders'),
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          HistoryCard(
              id: '#YG-1048',
              status: tr(context, 'جاري التحضير', 'Preparing'),
              restaurant: tr(context, 'مشويات الحارة', 'El Hara Grill'),
              amount: 'EGP 241.00',
              active: true,
              onTap: () => go(context, const OrderTrackingScreen())),
          const SizedBox(height: 10),
          HistoryCard(
              id: '#YG-1017',
              status: tr(context, 'تم التوصيل', 'Delivered'),
              restaurant: tr(context, 'كشري على أصوله', 'Koshary Aslo'),
              amount: 'EGP 115.00'),
          const SizedBox(height: 10),
          HistoryCard(
              id: '#YG-0992',
              status: tr(context, 'تم التوصيل', 'Delivered'),
              restaurant: tr(context, 'أفران البلد', 'Baladi Bakery'),
              amount: 'EGP 88.00'),
        ]),
        bottomNavigationBar: const CustomerNav(index: 1),
      );
}

class VendorMenuScreen extends StatefulWidget {
  const VendorMenuScreen({super.key});
  @override
  State<VendorMenuScreen> createState() => _VendorMenuScreenState();
}

class _VendorMenuScreenState extends State<VendorMenuScreen> {
  final available = [true, true, false];
  bool editOpen = false;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset('assets/images/logo.PNG')),
          title: const Text('YallaGo',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontWeight: FontWeight.w800)),
          actions: [
            LanguageButton(onTap: YallaScope.of(context).toggleLanguage)
          ],
        ),
        body: ListView(padding: _pagePadding, children: [
          const VendorHero(),
          const SizedBox(height: 20),
          SectionTitle(
              title: tr(context, 'الأصناف', 'Menu items'),
              action: tr(context, 'أضف صنف', 'Add item'),
              onAction: () => setState(() => editOpen = true)),
          if (editOpen)
            _MenuEditor(onClose: () => setState(() => editOpen = false)),
          VendorMenuRow(
              index: 0,
              enabled: available[0],
              onToggle: (value) => setState(() => available[0] = value),
              titleAr: 'ميكس جريل الحارة',
              titleEn: 'El Hara Mixed Grill',
              price: 210,
              asset: 'assets/images/yallago-grill.jpg',
              onEdit: () => setState(() => editOpen = true)),
          VendorMenuRow(
              index: 1,
              enabled: available[1],
              onToggle: (value) => setState(() => available[1] = value),
              titleAr: 'كفتة مشوية',
              titleEn: 'Charcoal Kofta',
              price: 135,
              asset: 'assets/images/yallago-grill.jpg',
              onEdit: () => setState(() => editOpen = true)),
          VendorMenuRow(
              index: 2,
              enabled: available[2],
              onToggle: (value) => setState(() => available[2] = value),
              titleAr: 'طاجن مكرونة باللحمة',
              titleEn: 'Pasta & Beef Casserole',
              price: 155,
              asset: 'assets/images/yallago-koshary.jpg',
              onEdit: () => setState(() => editOpen = true)),
        ]),
        bottomNavigationBar: const VendorNav(index: 0),
      );
}

class VendorOrdersScreen extends StatelessWidget {
  const VendorOrdersScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: Text(tr(context, 'طلبات جديدة', 'New orders')),
            actions: [
              LanguageButton(onTap: YallaScope.of(context).toggleLanguage)
            ]),
        body: ListView(padding: _pagePadding, children: [
          Text(tr(context, 'طلبات جديدة', 'New orders'),
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(
              tr(context, 'اتصرف بسرعة عشان تحافظ على وقت التحضير.',
                  'Act quickly to keep prep times on track.'),
              style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 16),
          SizedBox(
              height: 38,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                FilterChipWidget(
                    label: tr(context, 'وارد (٣)', 'Incoming (3)'),
                    active: true),
                FilterChipWidget(
                    label: tr(context, 'جاري التحضير', 'Preparing')),
                FilterChipWidget(label: tr(context, 'جاهز', 'Ready'))
              ])),
          const SizedBox(height: 14),
          const VendorOrderCard(
              id: '#YG-1048',
              minutes: 2,
              detailAr: 'ميكس جريل الحارة ×١ · عيش بلدي ×١',
              detailEn: 'Mixed Grill ×1 · Baladi bread ×1',
              amount: 241),
          const SizedBox(height: 10),
          const VendorOrderCard(
              id: '#YG-1049',
              minutes: 4,
              detailAr: 'كفتة مشوية ×٢ · سلطة طحينة ×١',
              detailEn: 'Charcoal Kofta ×2 · Tahini salad ×1',
              amount: 302),
          const SizedBox(height: 10),
          const VendorOrderCard(
              id: '#YG-1050',
              minutes: 6,
              detailAr: 'طاجن مكرونة باللحمة ×١',
              detailEn: 'Pasta & Beef Casserole ×1',
              amount: 155),
        ]),
        bottomNavigationBar: const VendorNav(index: 1),
      );
}

class VendorOrderDetailScreen extends StatefulWidget {
  const VendorOrderDetailScreen({super.key});
  @override
  State<VendorOrderDetailScreen> createState() =>
      _VendorOrderDetailScreenState();
}

enum VendorOrderStage { incoming, preparing, ready, rejected }

class _VendorOrderDetailScreenState extends State<VendorOrderDetailScreen> {
  VendorOrderStage stage = VendorOrderStage.incoming;
  @override
  Widget build(BuildContext context) {
    final stageLabel = switch (stage) {
      VendorOrderStage.incoming => tr(context, 'طلب جديد', 'New order'),
      VendorOrderStage.preparing => tr(context, 'جاري التحضير', 'Preparing'),
      VendorOrderStage.ready =>
        tr(context, 'جاهز للاستلام', 'Ready for pickup'),
      VendorOrderStage.rejected => tr(context, 'تم الرفض', 'Rejected'),
    };
    return DetailScaffold(
      title: '#YG-1048',
      child: ListView(padding: _pagePadding, children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.ink, AppColors.nile]),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(5))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('#YG-1048',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w800)),
              TicketLabel(label: stageLabel, light: true)
            ]),
            const SizedBox(height: 7),
            Text(
                tr(context, 'وصل منذ دقيقتين · الدفع عند الاستلام',
                    'Received 2 minutes ago · Cash on delivery'),
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 20),
        SectionTitle(title: tr(context, 'الأصناف', 'Items'), action: '2'),
        const SizedBox(height: 8),
        const _OrderLine(label: 'Mixed Grill × 1', amount: 210),
        const _OrderLine(label: 'Baladi Bread × 1', amount: 28),
        const _OrderLine(label: 'Delivery fee', amount: 18),
        const PaymentSummary(simple: true),
        const SizedBox(height: 18),
        SectionTitle(title: tr(context, 'ملاحظات العميل', 'Customer note')),
        const SizedBox(height: 8),
        InfoCard(
            icon: Icons.note_alt_outlined,
            title: tr(context, 'من فضلك من غير بصل في السلطة',
                'Please no onions in the salad'),
            body: tr(context, 'عنوان التسليم: المعادي، دجلة',
                'Delivery: Maadi, Degla')),
        const SizedBox(height: 18),
        if (stage == VendorOrderStage.incoming)
          _IncomingActions(
              onAccept: () =>
                  setState(() => stage = VendorOrderStage.preparing),
              onReject: () => setState(() => stage = VendorOrderStage.rejected))
        else if (stage == VendorOrderStage.preparing)
          PrimaryButton(
              label: tr(context, 'علّمه جاهز', 'Mark as ready'),
              icon: Icons.inventory_2_outlined,
              onTap: () => setState(() => stage = VendorOrderStage.ready))
        else if (stage == VendorOrderStage.ready)
          InfoCard(
              icon: Icons.check_circle_outline,
              title: tr(context, 'تمام، الطلب جاهز', 'All set — order ready'),
              body: tr(context, 'العميل اتبلغ إن طلبه جاهز للاستلام.',
                  'The customer has been notified the order is ready.'),
              selected: true)
        else
          InfoCard(
              icon: Icons.cancel_outlined,
              title: tr(context, 'تم رفض الطلب', 'Order rejected'),
              body: tr(context, 'هيتم إبلاغ العميل فورًا.',
                  'The customer will be notified immediately.')),
      ]),
    );
  }
}

class _IncomingActions extends StatelessWidget {
  const _IncomingActions({required this.onAccept, required this.onReject});
  final VoidCallback onAccept;
  final VoidCallback onReject;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            color: AppColors.mist,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(5)),
            border: BorderDirectional(
                start: BorderSide(color: AppColors.nile, width: 4))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tr(context, 'هل تقدر تنفذ الطلب؟', 'Can you fulfil this order?'),
              style:
                  const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 4),
          Text(
              tr(context, 'اختار وقت التحضير ثم أكّد القبول.',
                  'Choose prep time, then accept the order.'),
              style: const TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 10),
          const Wrap(spacing: 7, children: [
            ChoiceChip(label: Text('20 min'), selected: true),
            ChoiceChip(label: Text('30 min'), selected: false),
            ChoiceChip(label: Text('45 min'), selected: false)
          ]),
          const SizedBox(height: 13),
          Row(children: [
            Expanded(
                child: OutlinedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.close),
                    label: Text(tr(context, 'رفض', 'Reject')),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.hibiscus))),
            const SizedBox(width: 9),
            Expanded(
                child: FilledButton.icon(
                    onPressed: onAccept,
                    icon: const Icon(Icons.check),
                    label: Text(tr(context, 'قبول الطلب', 'Accept order')),
                    style: FilledButton.styleFrom(
                        backgroundColor: AppColors.nile)))
          ]),
        ]),
      );
}

class DetailScaffold extends StatelessWidget {
  const DetailScaffold({required this.title, required this.child, super.key});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(title), actions: [
        LanguageButton(onTap: YallaScope.of(context).toggleLanguage)
      ]),
      body: SafeArea(child: child));
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {required this.label,
      required this.icon,
      required this.onTap,
      this.critical = false,
      super.key});
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool critical;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 54,
        child: FilledButton.icon(
            onPressed: onTap,
            icon: Icon(icon),
            label: Text(label),
            style: FilledButton.styleFrom(
                backgroundColor: critical ? AppColors.hibiscus : AppColors.nile,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 15))),
      );
}

class QuantityControl extends StatelessWidget {
  const QuantityControl(
      {required this.value,
      required this.onChanged,
      this.compact = false,
      super.key});
  final int value;
  final ValueChanged<int> onChanged;
  final bool compact;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: AppColors.mist, borderRadius: BorderRadius.circular(11)),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.ltr,
            children: [
              IconButton(
                  onPressed: () => onChanged(value > 1 ? value - 1 : 1),
                  icon: const Icon(Icons.remove),
                  iconSize: compact ? 15 : 19,
                  visualDensity: VisualDensity.compact),
              SizedBox(
                  width: compact ? 16 : 22,
                  child: Text('$value',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w800))),
              IconButton(
                  onPressed: () => onChanged(value + 1),
                  icon: const Icon(Icons.add),
                  iconSize: compact ? 15 : 19,
                  visualDensity: VisualDensity.compact),
            ]),
      );
}

class Price extends StatelessWidget {
  const Price({required this.value, this.size = 13, super.key});
  final int value;
  final double size;
  @override
  Widget build(BuildContext context) => Text('EGP $value',
      textDirection: TextDirection.ltr,
      style: TextStyle(
          color: AppColors.nileDark,
          fontSize: size,
          fontWeight: FontWeight.w800));
}

class PaymentSummary extends StatelessWidget {
  const PaymentSummary({this.simple = false, super.key});
  final bool simple;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: AppColors.paper,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(17)),
        child: Column(children: [
          if (!simple) ...[
            const _OrderLine(label: 'Subtotal', amount: 238),
            const _OrderLine(label: 'Delivery fee', amount: 18),
            const _OrderLine(label: 'YallaGo discount', amount: -15)
          ],
          _OrderLine(
              label: tr(context, 'الإجمالي', 'Total'),
              amount: 241,
              total: true),
        ]),
      );
}

class _OrderLine extends StatelessWidget {
  const _OrderLine(
      {required this.label, required this.amount, this.total = false});
  final String label;
  final int amount;
  final bool total;
  @override
  Widget build(BuildContext context) => Container(
        margin: total ? const EdgeInsets.only(top: 8) : EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: total
            ? const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.line)))
            : null,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label,
              style: TextStyle(
                  color: total ? AppColors.ink : Colors.black54,
                  fontWeight: total ? FontWeight.w800 : FontWeight.w500)),
          Text('EGP $amount',
              textDirection: TextDirection.ltr,
              style: const TextStyle(fontWeight: FontWeight.w800))
        ]),
      );
}

class InfoCard extends StatelessWidget {
  const InfoCard(
      {required this.icon,
      required this.title,
      required this.body,
      this.selected = false,
      super.key});
  final IconData icon;
  final String title;
  final String body;
  final bool selected;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: selected ? AppColors.mist : AppColors.paper,
            border:
                Border.all(color: selected ? AppColors.nile : AppColors.line),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(5))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: selected ? AppColors.nile : AppColors.hibiscus),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(body,
                    style: const TextStyle(
                        color: Colors.black54, fontSize: 12, height: 1.45))
              ]))
        ]),
      );
}

class TrackingHero extends StatelessWidget {
  const TrackingHero({super.key});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [AppColors.nileDark, AppColors.nile]),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23),
                bottomRight: Radius.circular(5))),
        child: Column(
          children: [
            const Icon(Icons.ramen_dining_outlined,
                color: Colors.white, size: 34),
            const SizedBox(height: 8),
            Text(tr(context, 'طلبك في المطبخ', 'Your order is in the kitchen'),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 5),
            Text(
                tr(context, 'مشويات الحارة بدأت تحضّر طلبك.',
                    'El Hara Grill has started preparing your order.'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                    tr(context, 'يوصل خلال ٣٥ دقيقة', 'Arrives in 35 min'),
                    style: const TextStyle(
                        color: AppColors.nileDark,
                        fontWeight: FontWeight.w800)))
          ],
        ),
      );
}

class TrackingStep extends StatelessWidget {
  const TrackingStep(
      {required this.title,
      required this.subtitle,
      this.done = false,
      this.active = false,
      super.key});
  final String title;
  final String subtitle;
  final bool done;
  final bool active;
  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Column(children: [
            Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                    color: done
                        ? AppColors.green
                        : active
                            ? AppColors.mist
                            : AppColors.paper,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: done
                            ? AppColors.green
                            : active
                                ? AppColors.nile
                                : AppColors.line)),
                child: Icon(
                    done
                        ? Icons.check
                        : active
                            ? Icons.restaurant_outlined
                            : Icons.circle_outlined,
                    size: 15,
                    color: done ? Colors.white : AppColors.nile)),
            Expanded(child: Container(width: 2, color: AppColors.line))
          ]),
          const SizedBox(width: 12),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 15)),
                        const SizedBox(height: 3),
                        Text(subtitle,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 12))
                      ]))),
        ]),
      );
}

class HistoryCard extends StatelessWidget {
  const HistoryCard(
      {required this.id,
      required this.status,
      required this.restaurant,
      required this.amount,
      this.active = false,
      this.onTap,
      super.key});
  final String id;
  final String status;
  final String restaurant;
  final String amount;
  final bool active;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Ink(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: AppColors.paper,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(17)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(id,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              TicketLabel(label: status, light: active)
            ]),
            const SizedBox(height: 7),
            Text(restaurant,
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 5),
            Text(tr(context, 'منذ ساعتين', '2 hours ago'),
                style: const TextStyle(color: Colors.black54, fontSize: 12)),
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(amount,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              if (active)
                Text(tr(context, 'تابع الطلب', 'Track order'),
                    style: const TextStyle(
                        color: AppColors.nile, fontWeight: FontWeight.w800))
            ])
          ]),
        ),
      );
}

class VendorHero extends StatelessWidget {
  const VendorHero({super.key});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.ink, AppColors.nile]),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23),
                bottomRight: Radius.circular(5))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const TicketLabel(label: 'El Hara Grill', light: true),
          const SizedBox(height: 9),
          Text(tr(context, 'منيو اليوم', 'Today’s menu'),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(
              tr(context, 'حدّث أصنافك المتاحة عشان الطلبات تمشي بسلاسة.',
                  'Keep available items up to date for smoother service.'),
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const Divider(color: Colors.white24, height: 27),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            VendorKpi(value: '18', label: tr(context, 'صنف', 'items')),
            VendorKpi(value: '14', label: tr(context, 'متاح', 'live')),
            VendorKpi(value: '4', label: tr(context, 'موقوف', 'paused'))
          ]),
        ]),
      );
}

class VendorKpi extends StatelessWidget {
  const VendorKpi({required this.value, required this.label, super.key});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(children: [
        Text(value,
            textDirection: TextDirection.ltr,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11))
      ]);
}

class VendorMenuRow extends StatelessWidget {
  const VendorMenuRow(
      {required this.index,
      required this.enabled,
      required this.onToggle,
      required this.titleAr,
      required this.titleEn,
      required this.price,
      required this.asset,
      required this.onEdit,
      super.key});
  final int index;
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final String titleAr;
  final String titleEn;
  final int price;
  final String asset;
  final VoidCallback onEdit;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.line))),
        child: Row(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  Image.asset(asset, width: 60, height: 60, fit: BoxFit.cover)),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(tr(context, titleAr, titleEn),
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 5),
                Text(
                    'EGP $price · ${tr(context, enabled ? 'متاح للطلب' : 'موقوف مؤقتًا', enabled ? 'Available' : 'Temporarily off')}',
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(fontSize: 11, color: Colors.black54))
              ])),
          Column(children: [
            Switch(
                value: enabled,
                activeThumbColor: AppColors.nile,
                onChanged: onToggle),
            TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 15),
                label: Text(tr(context, 'تعديل', 'Edit')),
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w800)))
          ])
        ]),
      );
}

class _MenuEditor extends StatelessWidget {
  const _MenuEditor({required this.onClose});
  final VoidCallback onClose;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 6, bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: AppColors.mist,
            border: Border.all(color: AppColors.nile.withValues(alpha: .2)),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(17),
                bottomLeft: Radius.circular(17),
                bottomRight: Radius.circular(5))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tr(context, 'أضف أو عدّل صنف', 'Add or edit item'),
              style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          TextField(
              decoration: InputDecoration(
                  hintText: tr(context, 'اسم الصنف', 'Item name'))),
          const SizedBox(height: 9),
          const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Price (EGP)')),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
                child: OutlinedButton(
                    onPressed: onClose,
                    child: Text(tr(context, 'إلغاء', 'Cancel')))),
            const SizedBox(width: 8),
            Expanded(
                child: FilledButton(
                    onPressed: onClose,
                    style:
                        FilledButton.styleFrom(backgroundColor: AppColors.nile),
                    child: Text(tr(context, 'حفظ', 'Save'))))
          ])
        ]),
      );
}

class VendorOrderCard extends StatelessWidget {
  const VendorOrderCard(
      {required this.id,
      required this.minutes,
      required this.detailAr,
      required this.detailEn,
      required this.amount,
      super.key});
  final String id;
  final int minutes;
  final String detailAr;
  final String detailEn;
  final int amount;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => go(context, const VendorOrderDetailScreen()),
        borderRadius: BorderRadius.circular(17),
        child: Ink(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: AppColors.paper,
              border: Border.all(color: AppColors.line),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(17),
                  topRight: Radius.circular(17),
                  bottomLeft: Radius.circular(17),
                  bottomRight: Radius.circular(5))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(id,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              TicketLabel(
                  label: tr(context, 'جديد · $minutes د', 'New · ${minutes}m'))
            ]),
            const SizedBox(height: 9),
            Text(tr(context, detailAr, detailEn),
                style: const TextStyle(color: Colors.black54, fontSize: 12)),
            const Divider(height: 22),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Price(value: amount),
              Text('${tr(context, 'افتح الطلب', 'Open order')}  ‹',
                  style: const TextStyle(
                      color: AppColors.nile, fontWeight: FontWeight.w800))
            ])
          ]),
        ),
      );
}

class CustomerNav extends StatelessWidget {
  const CustomerNav({required this.index, super.key});
  final int index;
  @override
  Widget build(BuildContext context) => NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          if (value == 0) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
                (route) => false);
          }
          if (value == 1) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                (route) => false);
          }
          if (value == 2) go(context, const CartScreen());
        },
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: tr(context, 'الرئيسية', 'Home')),
          NavigationDestination(
              icon: const Icon(Icons.receipt_long_outlined),
              selectedIcon: const Icon(Icons.receipt_long),
              label: tr(context, 'طلباتي', 'Orders')),
          NavigationDestination(
              icon: Badge(
                  label: Text('${YallaScope.of(context).cartCount}'),
                  child: const Icon(Icons.shopping_bag_outlined)),
              selectedIcon: const Icon(Icons.shopping_bag),
              label: tr(context, 'السلة', 'Cart'))
        ],
      );
}

class VendorNav extends StatelessWidget {
  const VendorNav({required this.index, super.key});
  final int index;
  @override
  Widget build(BuildContext context) => NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          if (value == 0) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const VendorMenuScreen()),
                (route) => false);
          }
          if (value == 1) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const VendorOrdersScreen()),
                (route) => false);
          }
        },
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.restaurant_menu_outlined),
              selectedIcon: const Icon(Icons.restaurant_menu),
              label: tr(context, 'المنيو', 'Menu')),
          NavigationDestination(
              icon: const Icon(Icons.inbox_outlined),
              selectedIcon: const Icon(Icons.inbox),
              label: tr(context, 'الطلبات', 'Orders'))
        ],
      );
}

class CartDock extends StatelessWidget {
  const CartDock({required this.onTap, super.key});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
        elevation: 9,
        borderRadius: BorderRadius.circular(17),
        color: AppColors.hibiscus,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: Container(
            width: 350,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            tr(
                                context,
                                '${YallaScope.of(context).cartCount} أصناف في السلة',
                                '${YallaScope.of(context).cartCount} items in cart'),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12)),
                        const Text('EGP 241.00',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800))
                      ]),
                  Text(tr(context, 'شوف السلة', 'View cart'),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800))
                ]),
          ),
        ),
      );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(
      {required this.title, this.action, this.onAction, super.key});
  final String title;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        if (action != null)
          TextButton(
              onPressed: onAction,
              child: Text(action!,
                  style: const TextStyle(fontWeight: FontWeight.w800)))
      ]);
}

class TicketLabel extends StatelessWidget {
  const TicketLabel({required this.label, this.light = false, super.key});
  final String label;
  final bool light;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
          color: light ? Colors.white24 : AppColors.mist,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(7),
              bottomLeft: Radius.circular(7),
              bottomRight: Radius.circular(2),
              topRight: Radius.circular(7)),
          border: BorderDirectional(
              start: BorderSide(
                  color: light ? Colors.white : AppColors.nile, width: 3))),
      child: Text(label,
          style: TextStyle(
              color: light ? Colors.white : AppColors.nileDark,
              fontSize: 9,
              fontWeight: FontWeight.w800)));
}

class FilterChipWidget extends StatelessWidget {
  const FilterChipWidget({required this.label, this.active = false, super.key});
  final String label;
  final bool active;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: ChoiceChip(
          label: Text(label),
          selected: active,
          selectedColor: AppColors.mist,
          shape: StadiumBorder(
              side:
                  BorderSide(color: active ? AppColors.nile : AppColors.line)),
          onSelected: (_) {}));
}

class RouteRibbon extends StatelessWidget {
  const RouteRibbon({super.key});
  @override
  Widget build(BuildContext context) => Row(children: [
        const Expanded(
            child: Divider(
                color: AppColors.nile,
                thickness: 1.5,
                indent: 2,
                endIndent: 6)),
        Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
                color: AppColors.hibiscus,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Color(0x33E84757), spreadRadius: 4)
                ])),
        const Expanded(
            child: Divider(
                color: AppColors.nile, thickness: 1.5, indent: 6, endIndent: 2))
      ]);
}

class LanguageButton extends StatelessWidget {
  const LanguageButton({required this.onTap, super.key});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => TextButton(
      onPressed: onTap,
      child: Text(YallaScope.of(context).arabic ? 'EN' : 'ع',
          style: const TextStyle(fontWeight: FontWeight.w800)));
}

class _RouteArc extends StatelessWidget {
  const _RouteArc({required this.size, required this.color});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle, border: Border.all(color: color, width: 2)));
}
