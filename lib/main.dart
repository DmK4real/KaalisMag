import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/opinion_api.dart';
import 'services/partners_api.dart';
import 'services/portrait_api.dart';

void main() {
  runApp(const KaalisApp());
}

const kaalisPrimary = Color(0xFF9F3A25);
const kaalisText = Color(0xFF3B1C14);
const kaalisMuted = Color(0xFF7C7C7C);
const kaalisBorder = Color(0xFFE6DAD0);
const newsletterBg = Color(0xFFE9C85A);
const newsletterText = Color(0xFF111111);
const newsletterMuted = Color(0xFF6B6B6B);
const double _sectionSpacing = 96.0;

class _Routes {
  static const home = '/';
  static const opinion = '/opinion';
  static const portrait = '/portrait';
  static const lieux = '/lieux';
  static const style = '/style';
  static const community = '/community';
  static const faq = '/faq';
  static const privacy = '/privacy';
  static const partners = '/partners';
  static const socialTiktok = '/social-tiktok';
  static const socialFacebook = '/social-facebook';
  static const socialInstagram = '/social-instagram';
  static const socialX = '/social-x';
  static const socialYoutube = '/social-youtube';
}

class _NavLink {
  final String label;
  final String route;
  const _NavLink(this.label, this.route);
}

const _navLinks = [
  _NavLink('Opinion', _Routes.opinion),
  _NavLink('Portrait', _Routes.portrait),
  _NavLink('Lieux', _Routes.lieux),
  _NavLink('Style', _Routes.style),
  _NavLink('Communaut\u00E9', _Routes.community),
];

const _grayscaleMatrix = <double>[
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
];

class NewsletterController extends ChangeNotifier {
  bool _isOpen = false;
  FocusNode? _invokerFocus;

  bool get isOpen => _isOpen;

  void open({FocusNode? invoker}) {
    _invokerFocus = invoker;
    if (_isOpen) return;
    _isOpen = true;
    notifyListeners();
  }

  void close() {
    if (!_isOpen) return;
    _isOpen = false;
    notifyListeners();
    final node = _invokerFocus;
    if (node != null && node.canRequestFocus) {
      node.requestFocus();
    }
    _invokerFocus = null;
  }
}

class NewsletterProvider extends InheritedNotifier<NewsletterController> {
  const NewsletterProvider({
    super.key,
    required NewsletterController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static NewsletterController of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<NewsletterProvider>();
    assert(provider != null, 'NewsletterProvider not found in context');
    return provider!.notifier!;
  }

  @override
  bool updateShouldNotify(NewsletterProvider oldWidget) => notifier != oldWidget.notifier;
}

class _LieuxArticle {
  final String title;
  final String date;
  final String imageUrl;
  const _LieuxArticle({required this.title, required this.date, required this.imageUrl});
}

const _lieuxArticles = [
  _LieuxArticle(
    title: 'La maison qui r\u00E9veille le quartier',
    date: '22/04/2030',
    imageUrl: 'https://images.unsplash.com/photo-1505691723518-36a5ac3be353?q=80&w=1600&auto=format&fit=crop',
  ),
  _LieuxArticle(
    title: 'Les jardins suspendus d\'Abidjan',
    date: '22/04/2030',
    imageUrl: 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?q=80&w=1200&auto=format&fit=crop',
  ),
  _LieuxArticle(
    title: 'Un h\u00F4tel art d\u00E9co revisite les ann\u00E9es 70',
    date: '22/04/2030',
    imageUrl: 'https://images.unsplash.com/photo-1479839672679-a46483c0e7c8?q=80&w=1200&auto=format&fit=crop',
  ),
  _LieuxArticle(
    title: 'Le march\u00E9 cach\u00E9 des artisans',
    date: '22/04/2030',
    imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1200&auto=format&fit=crop',
  ),
  _LieuxArticle(
    title: 'Une adresse seaside minimaliste',
    date: '22/04/2030',
    imageUrl: 'https://images.unsplash.com/photo-1529429617124-aee711a5f676?q=80&w=1200&auto=format&fit=crop',
  ),
];

class _StyleArticle {
  final String title;
  final String date;
  final String imageUrl;
  const _StyleArticle({required this.title, required this.date, required this.imageUrl});
}

const _styleArticles = [
  _StyleArticle(
    title: 'Le denim sculpt\u00E9 du printemps',
    date: '22/04/2030',
    imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=1600&auto=format&fit=crop',
  ),
  _StyleArticle(
    title: 'Palette \u00E9pic\u00E9e pour l\u2019\u00E9t\u00E9',
    date: '22/04/2030',
    imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=1200&auto=format&fit=crop',
  ),
  _StyleArticle(
    title: 'Accessoires en raphia, le nouveau chic',
    date: '22/04/2030',
    imageUrl: 'https://images.unsplash.com/photo-1514996937319-344454492b37?q=80&w=1200&auto=format&fit=crop',
  ),
  _StyleArticle(
    title: 'C\u00E9ramique et soie : un mix inattendu',
    date: '22/04/2030',
    imageUrl: 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?q=80&w=1200&auto=format&fit=crop',
  ),
  _StyleArticle(
    title: 'La garde-robe minimaliste revisit\u00E9e',
    date: '22/04/2030',
    imageUrl: 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?q=80&w=1200&auto=format&fit=crop',
  ),
];

class KaalisApp extends StatefulWidget {
  const KaalisApp({super.key});

  @override
  State<KaalisApp> createState() => _KaalisAppState();
}

class _KaalisAppState extends State<KaalisApp> {
  late final NewsletterController _newsletterController = NewsletterController();

  @override
  void dispose() {
    _newsletterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: kaalisPrimary, primary: kaalisPrimary),
      textTheme: GoogleFonts.mulishTextTheme().apply(bodyColor: kaalisText, displayColor: kaalisText),
      scaffoldBackgroundColor: Colors.white,
      useMaterial3: true,
    );
    return NewsletterProvider(
      controller: _newsletterController,
      child: MaterialApp(
        title: 'Kaalis',
        theme: theme,
        debugShowCheckedModeBanner: false,
        initialRoute: _Routes.home,
        routes: {
          _Routes.home: (context) => const HomePage(),
          _Routes.opinion: (context) => const OpinionPage(),
          _Routes.portrait: (context) => const PortraitPage(),
          _Routes.lieux: (context) => const LieuxPage(),
          _Routes.style: (context) => const StylePage(),
          _Routes.community: (context) => const CommunityPage(),
          _Routes.faq: (context) => const FAQPage(),
          _Routes.privacy: (context) => const PrivacyPage(),
          _Routes.partners: (context) => const PartnersPage(),
          _Routes.socialTiktok: (context) => const SocialPage(title: 'TikTok', message: 'Retrouvez nos dernières vidéos TikTok bientôt disponibles.'),
          _Routes.socialFacebook: (context) => const SocialPage(title: 'Facebook', message: 'La page Facebook Kaalis est en cours de préparation.'),
          _Routes.socialInstagram: (context) => const SocialPage(title: 'Instagram', message: 'Découvrez bientôt notre univers Instagram.'),
          _Routes.socialX: (context) => const SocialPage(title: 'X', message: 'Nos actualités X arrivent très vite.'),
          _Routes.socialYoutube: (context) => const SocialPage(title: 'Youtube', message: 'Les formats vidéo Youtube Kaalis sont en production.'),
        },
        builder: (context, child) {
          return Stack(
            children: [
              child ?? const SizedBox.shrink(),
              NewsletterDrawer(controller: _newsletterController),
            ],
          );
        },
      ),
    );
  }
}

List<Widget> _buildPageSlivers({required String activeRoute, required List<Widget> body, Color? headerBackground}) {
  return [
    SliverToBoxAdapter(child: _Header(activeRoute: activeRoute, backgroundColor: headerBackground)),
    ...body.map((widget) => SliverToBoxAdapter(child: widget)),
    SliverToBoxAdapter(child: const _Footer()),
  ];
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: _buildPageSlivers(
          activeRoute: _Routes.home,
          body: [
            const _Hero(),
            const _SectionDivider(),
            SectionOpinion(),
            const _SectionDivider(),
            SectionPortrait(),
            const _SectionDivider(),
            SectionChoix(),
            const _SectionDivider(),
          ],
        ),
      ),
    );
  }
}

class _Container extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? maxWidth;
  const _Container({
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 36),
    this.maxWidth = 1220,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: maxWidth != null
            ? BoxConstraints(maxWidth: maxWidth!)
            : const BoxConstraints(),
        padding: padding,
        child: child,
      ),
    );
  }
}



class _Header extends StatelessWidget {
  final String? activeRoute;
  final Color? backgroundColor;
  const _Header({required this.activeRoute, this.backgroundColor});

  // Navigation items are defined in _navLinks.
  @override
  Widget build(BuildContext context) {
    final bool overlay = backgroundColor != null && backgroundColor!.a <= 0;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: overlay ? null : backgroundColor ?? Colors.white,
        gradient: overlay
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xA0FFFFFF),
                  Color(0x80FFFFFF),
                  Color(0x40FFFFFF),
                ],
              )
            : null,
      ),
      child: _Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        maxWidth: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 820;
            final isTight = constraints.maxWidth < 420;
            final spacing = isTight ? 24.0 : 40.0;
            final fontSize = isTight ? 15.0 : 17.0;

            Widget navLinks = Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (var i = 0; i < _navLinks.length; i++) ...[
                      GestureDetector(
                        onTap: () {
                          final current = ModalRoute.of(context)?.settings.name ?? _Routes.home;
                          if (current == _navLinks[i].route) return;
                          Navigator.of(context).pushReplacementNamed(_navLinks[i].route);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            _navLinks[i].label,
                            style: GoogleFonts.mulish(
                              textStyle: TextStyle(
                                fontSize: fontSize,
                                fontWeight: activeRoute == _navLinks[i].route ? FontWeight.w800 : FontWeight.w600,
                                letterSpacing: 0.5,
                                color: kaalisPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (i < _navLinks.length - 1) SizedBox(width: spacing),
                    ],
                  ],
                ),
              ),
            );

            Widget brand = _HeaderBrand(activeRoute: activeRoute, fontSize: isCompact ? 84 : 104);

            Widget actions = Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 42,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rechercher',
                        style: GoogleFonts.mulish(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                            color: kaalisPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 168,
                        height: 2,
                        color: kaalisPrimary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                const Icon(Icons.bookmark_border, size: 32, color: kaalisPrimary),
                const SizedBox(width: 24),
                Image.asset(
                  'assets/logo.png',
                  color: kaalisPrimary,
                  width: 62,
                  height: 62,
                  filterQuality: FilterQuality.high,
                ),
              ],
            );

            final content = Padding(
              padding: const EdgeInsets.only(top: 80, bottom: 56),
              child: isCompact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: brand),
                            const SizedBox(width: 24),
                            Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: actions)),
                          ],
                        ),
                        const SizedBox(height: 28),
                        navLinks,
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: navLinks),
                        brand,
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: actions,
                          ),
                        ),
                      ],
                    ),
            );

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                content,
                Container(height: 3, width: double.infinity, color: kaalisPrimary),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeaderBrand extends StatelessWidget {
  final String? activeRoute;
  final double fontSize;
  const _HeaderBrand({required this.activeRoute, required this.fontSize});

  bool get _isHome => activeRoute == _Routes.home;

  void _goHome(BuildContext context) {
    if (_isHome) return;
    Navigator.of(context).pushReplacementNamed(_Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final text = Text(
      'Kaalis',
      style: GoogleFonts.playfairDisplay(
        textStyle: TextStyle(
          color: kaalisPrimary,
          fontWeight: FontWeight.w500,
          fontSize: fontSize,
          height: 1,
          letterSpacing: 1.6,
        ),
      ),
    );

    if (_isHome) {
      return Semantics(label: 'Kaalis', child: text);
    }

    return FocusableActionDetector(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _goHome(context);
            return null;
          },
        ),
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _goHome(context),
          child: Semantics(
            button: true,
            label: 'Revenir à l’accueil Kaalis',
            child: text,
          ),
        ),
      ),
    );
  }
}

class OpinionPage extends StatefulWidget {
  const OpinionPage({super.key});

  @override
  State<OpinionPage> createState() => _OpinionPageState();
}

class _OpinionPageState extends State<OpinionPage> {
  late final Future<OpinionData> _future = OpinionRepository.instance.fetch();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<OpinionData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _AsyncSectionLoading(message: 'Chargement des articles Opinion…');
          }
          if (snapshot.hasError) {
            return const _SectionPlaceholder(
              title: 'Opinion',
              message: 'Impossible d’afficher les articles pour le moment.',
            );
          }
          final data = snapshot.data;
          if (data == null || data.articles.isEmpty) {
            return const _SectionPlaceholder(
              title: 'Opinion',
              message: 'Aucun article disponible pour le moment.',
            );
          }

          final hero = data.articles.first;
          final others = data.articles.skip(1).toList();
          return CustomScrollView(
            slivers: _buildPageSlivers(
              activeRoute: _Routes.opinion,
              body: [
                _OpinionHero(article: hero),
                _OpinionGrid(articles: others),
                const _SectionDivider(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PortraitPage extends StatefulWidget {
  const PortraitPage({super.key});

  @override
  State<PortraitPage> createState() => _PortraitPageState();
}

class _PortraitPageState extends State<PortraitPage> {
  late final Future<PortraitData> _future = PortraitRepository.instance.fetch();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<PortraitData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _AsyncSectionLoading(message: 'Chargement des portraits…');
          }
          if (snapshot.hasError) {
            return const _SectionPlaceholder(
              title: 'Portrait',
              message: 'Impossible d’afficher les portraits pour le moment.',
            );
          }
          final data = snapshot.data;
          if (data == null || data.features.isEmpty) {
            return const _SectionPlaceholder(
              title: 'Portrait',
              message: 'Aucun portrait disponible pour le moment.',
            );
          }
          final hero = data.features.first;
          final secondary = data.features.skip(1).toList();
          return CustomScrollView(
            slivers: _buildPageSlivers(
              activeRoute: _Routes.portrait,
              body: [
                _PortraitHero(feature: hero),
                for (final feature in secondary) _PortraitSplit(feature: feature),
                const _SectionDivider(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class LieuxPage extends StatelessWidget {
  const LieuxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: _buildPageSlivers(
          activeRoute: _Routes.lieux,
          body: [
            const SectionLieux(),
            const _SectionDivider(),
          ],
        ),
      ),
    );
  }
}

class StylePage extends StatelessWidget {
  const StylePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: _buildPageSlivers(
          activeRoute: _Routes.style,
          body: [
            const SectionStyle(),
            const _SectionDivider(),
          ],
        ),
      ),
    );
  }
}

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: _buildPageSlivers(
          activeRoute: _Routes.community,
          body: [
            const SectionCommunity(),
            const _SectionDivider(),
          ],
        ),
      ),
    );
  }
}

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _InfoScaffold(
      route: _Routes.faq,
      title: 'FAQ',
      message: 'Toutes les réponses aux questions fréquentes seront publiées très bientôt.',
    );
  }
}

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PrivacyScaffold();
  }
}

class PartnersPage extends StatelessWidget {
  const PartnersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PartnersScaffold();
  }
}

class SocialPage extends StatelessWidget {
  final String title;
  final String message;
  const SocialPage({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name ?? _Routes.home;
    return _InfoScaffold(route: route, title: title, message: message);
  }
}

class _InfoScaffold extends StatelessWidget {
  final String route;
  final String title;
  final String message;
  const _InfoScaffold({required this.route, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: _buildPageSlivers(
          activeRoute: route,
          body: [
            _SectionPlaceholder(title: title, message: message),
            const _SectionDivider(),
          ],
        ),
      ),
    );
  }
}

class _PartnersScaffold extends StatefulWidget {
  const _PartnersScaffold();

  @override
  State<_PartnersScaffold> createState() => _PartnersScaffoldState();
}

class _PartnersScaffoldState extends State<_PartnersScaffold> {
  bool _contactOpen = false;
  late Future<List<PartnerOpportunity>> _partnersFuture;
  final PartnersApiClient _apiClient = PartnersApiClient();

  void _openContact() => setState(() => _contactOpen = true);
  void _closeContact() => setState(() => _contactOpen = false);

  @override
  void initState() {
    super.initState();
    _partnersFuture = _apiClient.fetchOpportunities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: _buildPageSlivers(
              activeRoute: _Routes.partners,
              body: [
                _PartnersContent(future: _partnersFuture, onContactTap: _openContact),
                const _SectionDivider(),
              ],
            ),
          ),
          if (_contactOpen) _PartnerContactModal(onClose: _closeContact),
        ],
      ),
    );
  }
}

class _PartnersContent extends StatelessWidget {
  final Future<List<PartnerOpportunity>> future;
  final VoidCallback onContactTap;
  const _PartnersContent({required this.future, required this.onContactTap});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PartnerOpportunity>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _AsyncSectionLoading(message: 'Chargement des opportunités…');
        }
        if (snapshot.hasError) {
          return _SectionPlaceholder(
            title: 'Partenariats',
            message: 'Impossible de récupérer les opportunités (${snapshot.error}).',
          );
        }
        final sections = snapshot.data;
        if (sections == null || sections.isEmpty) {
          return const _SectionPlaceholder(
            title: 'Partenariats',
            message: 'Aucune opportunité disponible pour le moment.',
          );
        }

        return _Container(
          padding: const EdgeInsets.fromLTRB(48, 64, 48, 96),
          maxWidth: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var i = 0; i < sections.length; i++) ...[
                _PartnerRow(data: sections[i], onContactTap: onContactTap),
                if (i < sections.length - 1) const SizedBox(height: 96),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _AsyncSectionLoading extends StatelessWidget {
  final String message;
  const _AsyncSectionLoading({required this.message});

  @override
  Widget build(BuildContext context) {
    return _Container(
      padding: const EdgeInsets.fromLTRB(48, 64, 48, 96),
      maxWidth: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 80,
            width: 80,
            child: CircularProgressIndicator(strokeWidth: 5, color: kaalisPrimary),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: const TextStyle(color: kaalisText, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _PartnerRow extends StatelessWidget {
  final PartnerOpportunity data;
  final VoidCallback onContactTap;
  const _PartnerRow({required this.data, required this.onContactTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1000;
        final media = _PartnerMedia(isWide: isWide);
        final content = _PartnerContentBlock(
          data: data,
          isWide: isWide,
          onContactTap: onContactTap,
        );

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 9, child: media),
              const SizedBox(width: 48),
              Expanded(flex: 11, child: content),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            media,
            const SizedBox(height: 32),
            content,
          ],
        );
      },
    );
  }
}

class _PartnerMedia extends StatelessWidget {
  final bool isWide;
  const _PartnerMedia({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: isWide ? 3 / 4 : 16 / 9,
      child: Container(
        decoration: const BoxDecoration(
          color: kaalisPrimary,
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ),
    );
  }
}

class _PartnerContentBlock extends StatelessWidget {
  final PartnerOpportunity data;
  final bool isWide;
  final VoidCallback onContactTap;
  const _PartnerContentBlock({
    required this.data,
    required this.isWide,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleSize = data.primary
        ? (isWide ? 64.0 : 44.0)
        : (isWide ? 48.0 : 36.0);
    final titleWidget = Text(
      data.title,
      style: GoogleFonts.playfairDisplay(
        textStyle: TextStyle(
          fontSize: titleSize,
          height: 1.05,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF111111),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleWidget,
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final bullet in data.bullets)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        '•',
                        style: TextStyle(color: Color(0xFF3A3A3A), fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        bullet,
                        style: GoogleFonts.mulish(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            height: 1.45,
                            color: Color(0xFF3A3A3A),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 28),
        _PartnerCTA(onPressed: onContactTap),
      ],
    );
  }
}

class _PartnerCTA extends StatefulWidget {
  final VoidCallback onPressed;
  const _PartnerCTA({required this.onPressed});

  @override
  State<_PartnerCTA> createState() => _PartnerCTAState();
}

class _PartnerCTAState extends State<_PartnerCTA> {
  bool _hovering = false;

  void _setHover(bool value) {
    if (_hovering == value) return;
    setState(() => _hovering = value);
  }

  @override
  Widget build(BuildContext context) {
    const background = kaalisPrimary;
    final foreground = _hovering ? background : Colors.white;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: (_) => _setHover(true),
        onTapUp: (_) => _setHover(false),
        onTapCancel: () => _setHover(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: _hovering ? Colors.white : background,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: background, width: 2),
          ),
          child: Text(
            'Contacter l’équipe',
            style: GoogleFonts.mulish(
              textStyle: TextStyle(
                fontWeight: FontWeight.w700,
                color: foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PartnerContactModal extends StatefulWidget {
  final VoidCallback onClose;
  const _PartnerContactModal({required this.onClose});

  @override
  State<_PartnerContactModal> createState() => _PartnerContactModalState();
}

class _PartnerContactModalState extends State<_PartnerContactModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _nameFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  void _resetFields() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _companyController.clear();
    _emailController.clear();
    _subjectController.clear();
    _messageController.clear();
  }

  void _handleClose() {
    _resetFields();
    widget.onClose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Merci ! Nous revenons vers vous rapidement.')),
      );
      _handleClose();
    }
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    FocusNode? focusNode,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.mulish(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          maxLines: maxLines,
          cursorColor: Colors.black87,
          style: const TextStyle(color: Color(0xFF111111)),
          decoration: _inputDecoration(),
          validator: (value) => (value?.trim().isEmpty ?? true) ? 'Champ requis' : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          GestureDetector(
            onTap: _handleClose,
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Focus(
                autofocus: true,
                onKeyEvent: (node, event) {
                  if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
                    _handleClose();
                    return KeyEventResult.handled;
                  }
                  return KeyEventResult.ignored;
                },
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Material(
                    color: kaalisPrimary,
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                    elevation: 8,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(26, 34, 26, 30),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Remplir la fiche contact',
                                  style: GoogleFonts.mulish(
                                    textStyle: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                _buildField(
                                  label: 'Prénom et NOM',
                                  controller: _nameController,
                                  focusNode: _nameFocus,
                                ),
                                const SizedBox(height: 14),
                                _buildField(
                                  label: 'Nom de la marque/entreprise',
                                  controller: _companyController,
                                ),
                                const SizedBox(height: 14),
                                _buildField(
                                  label: 'Email',
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 14),
                                _buildField(
                                  label: 'Sujet',
                                  controller: _subjectController,
                                ),
                                const SizedBox(height: 14),
                                _buildField(
                                  label: 'Message',
                                  controller: _messageController,
                                  maxLines: 5,
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0B2A78),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  onPressed: _submit,
                                  child: const Text('Envoyer'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            onPressed: _handleClose,
                            icon: const Icon(Icons.close, color: Colors.white, size: 26),
                            tooltip: 'Fermer',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _PrivacyScaffold extends StatelessWidget {
  const _PrivacyScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: _buildPageSlivers(
          activeRoute: _Routes.privacy,
          body: const [
            _PrivacyContent(),
            _SectionDivider(),
          ],
        ),
      ),
    );
  }
}

class _PrivacyContent extends StatelessWidget {
  const _PrivacyContent();

  static const _sections = [
    (
      title: 'Données collectées',
      paragraphs: [
        'Nous collectons votre prénom, nom et adresse email lorsque vous vous abonnez à notre newsletter ou nous contactez via un formulaire. Nous collectons également des données de navigation (cookies, pages visitées) via des outils d’analyse pour améliorer notre site.'
      ],
      bullets: <String>[]
    ),
    (
      title: 'Utilisation de vos données',
      paragraphs: [
        'Vos données servent exclusivement à :',
      ],
      bullets: [
        'vous envoyer notre newsletter,',
        'répondre à vos messages,',
        'vous informer de nos événements,',
        'améliorer l’expérience et le contenu de notre site.',
      ]
    ),
    (
      title: 'Partage de vos données',
      paragraphs: [
        'Nous partageons vos données uniquement avec nos prestataires techniques (hébergement du site, service d’envoi d’emails, solution d’analytics) strictement pour fournir nos services. Nous ne vendons jamais vos données.'
      ],
      bullets: <String>[]
    ),
    (
      title: 'Conservation',
      paragraphs: [
        'Nous conservons vos données tant que vous êtes abonné·e, puis 3 ans après votre dernier contact. Les cookies sont conservés pour une durée maximale de 13 mois.'
      ],
      bullets: <String>[]
    ),
    (
      title: 'Vos droits',
      paragraphs: [
        'Conformément à la réglementation applicable, vous disposez des droits d’accès, de rectification, d’effacement, d’opposition, de limitation et de portabilité de vos données personnelles. Vous pouvez vous désabonner de la newsletter via le lien présent en bas de chaque email.'
      ],
      bullets: <String>[]
    ),
    (
      title: 'Contact',
      paragraphs: [
        'Pour toute question ou demande concernant vos données : contact@kaalismagazine.com'
      ],
      bullets: <String>[]
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double titleSize = 84;
    if (width < 1000) {
      titleSize = 64;
    }
    if (width < 640) {
      titleSize = 44;
    }

    return _Container(
      padding: const EdgeInsets.fromLTRB(48, 72, 48, 72),
      maxWidth: double.infinity,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Politique de Confidentialité',
                  softWrap: false,
                  style: GoogleFonts.playfairDisplay(
                    textStyle: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111111),
                      height: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Kaalis Magazine respecte votre vie privée et s’engage à protéger vos données personnelles.',
                style: GoogleFonts.mulish(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kaalisPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              for (final section in _sections) ...[
                Text(
                  section.title,
                  style: GoogleFonts.mulish(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                for (final paragraph in section.paragraphs) ...[
                  Text(
                    paragraph,
                    style: GoogleFonts.mulish(
                      textStyle: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF3A3A3A),
                        height: 1.55,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (section.bullets.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final bullet in section.bullets) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(color: Color(0xFF3A3A3A), fontSize: 15)),
                              Expanded(
                                child: Text(
                                  bullet,
                                  style: GoogleFonts.mulish(
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF3A3A3A),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 12),
              Text(
                'Dernière mise à jour : 07/11/2025',
                style: GoogleFonts.mulish(
                  textStyle: const TextStyle(
                    fontSize: 13,
                    color: kaalisMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return _Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      maxWidth: double.infinity,
      child: Container(
        margin: const EdgeInsets.only(top: 96, bottom: 128),
        height: 540,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4D83C2), Color(0xFFAED2EE)],
          ),
          border: Border.all(color: Color(0xFFE7E7E7)),
        ),
        padding: const EdgeInsets.fromLTRB(96, 144, 96, 128),
        alignment: Alignment.bottomLeft,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'A la Une :\n',
                style: GoogleFonts.playfairDisplay(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 88,
                    height: 1.08,
                  ),
                ),
              ),
              TextSpan(
                text: 'Article mis en avant',
                style: GoogleFonts.playfairDisplay(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 128,
                    height: 1.05,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return _Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      maxWidth: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: _sectionSpacing),
          Container(height: 3, width: double.infinity, color: kaalisPrimary),
          const SizedBox(height: _sectionSpacing),
        ],
      ),
    );
  }
}

class SectionHead extends StatelessWidget {
  final String title;
  final String? action;
  final bool showDivider;
  const SectionHead({super.key, required this.title, this.action, this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    return _Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      maxWidth: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showDivider) ...[
            Container(height: 3, color: kaalisPrimary),
            const SizedBox(height: 32),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    textStyle: const TextStyle(
                      color: kaalisPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 88,
                      height: 0.95,
                    ),
                  ),
                ),
              ),
              if (action != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    action!,
                    style: GoogleFonts.mulish(
                      textStyle: const TextStyle(
                        color: kaalisPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 0.6,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class SectionOpinion extends StatefulWidget {
  const SectionOpinion({super.key});

  @override
  State<SectionOpinion> createState() => _SectionOpinionState();
}

class _SectionOpinionState extends State<SectionOpinion> {
  late final Future<OpinionData> _future = OpinionRepository.instance.fetch();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OpinionData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _AsyncSectionLoading(message: 'Chargement des articles Opinion…');
        }
        if (snapshot.hasError) {
          return const _SectionPlaceholder(
            title: 'Opinion',
            message: 'Impossible d’afficher les articles pour le moment.',
          );
        }
        final data = snapshot.data;
        if (data == null || data.homeCards.isEmpty) {
          return const _SectionPlaceholder(
            title: 'Opinion',
            message: 'Aucun article disponible pour le moment.',
          );
        }

        final cards = data.homeCards;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHead(title: 'Opinion', action: 'Voir Plus', showDivider: false),
            const SizedBox(height: _sectionSpacing),
            _Container(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              maxWidth: double.infinity,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const gap = 32.0;
                  final width = constraints.maxWidth;
                  if (width >= 1080 && cards.length >= 3) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _OpinionCard(data: cards[0], isPrimary: true)),
                        const SizedBox(width: gap),
                        Expanded(child: _OpinionCard(data: cards[1])),
                        const SizedBox(width: gap),
                        Expanded(child: _OpinionCard(data: cards[2])),
                      ],
                    );
                  }

                  if (width >= 720 && cards.length >= 3) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _OpinionCard(data: cards[0], isPrimary: true),
                        const SizedBox(height: gap),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _OpinionCard(data: cards[1])),
                            const SizedBox(width: gap),
                            Expanded(child: _OpinionCard(data: cards[2])),
                          ],
                        ),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _OpinionCard(data: cards.first, isPrimary: true),
                      const SizedBox(height: gap),
                      for (final card in cards.skip(1)) ...[
                        _OpinionCard(data: card),
                        const SizedBox(height: gap),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OpinionCard extends StatelessWidget {
  final OpinionHomeCard data;
  final bool isPrimary;
  const _OpinionCard({required this.data, this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    final aspectRatio = isPrimary ? 4 / 3 : 3 / 2;
    final titleStyle = GoogleFonts.mulish(
      textStyle: TextStyle(
        fontSize: isPrimary ? 28 : 24,
        fontWeight: FontWeight.w800,
        height: 1.25,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: aspectRatio,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            child: Image.network(
              data.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFE0E0E0)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(data.title, style: titleStyle),
        const SizedBox(height: 8),
        Text(
          data.date,
          style: GoogleFonts.mulish(
            textStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9A9A9A),
              letterSpacing: 0.4,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          data.description,
          style: GoogleFonts.mulish(
            textStyle: const TextStyle(
              fontSize: 15,
              color: Color(0xFF6A6A6A),
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

class _OpinionHero extends StatelessWidget {
  final OpinionArticle article;
  const _OpinionHero({required this.article});

  @override
  Widget build(BuildContext context) {
    return _Container(
      padding: const EdgeInsets.fromLTRB(48, 72, 48, 40),
      maxWidth: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Builder(
            builder: (context) {
              final width = MediaQuery.of(context).size.width;
              double fontSize = 84;
              if (width < 640) {
                fontSize = 44;
              } else if (width < 1000) {
                fontSize = 64;
              }
              return Text(
                article.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  textStyle: TextStyle(
                    color: const Color(0xFF131313),
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize,
                    height: 1,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 520;
              if (isNarrow) {
                return Column(
                  children: [
                    Text(
                      article.date,
                      style: GoogleFonts.mulish(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7C7C7C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _ReadMoreLink(onTap: () {}),
                  ],
                );
              }

              return Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        article.date,
                        style: GoogleFonts.mulish(
                          textStyle: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7C7C7C),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _ReadMoreLink(onTap: () {}),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              child: Image.network(
                article.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(color: const Color(0xFFE8E8E8));
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFE8E8E8),
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_outlined, size: 48, color: Color(0xFFB0B0B0)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OpinionGrid extends StatelessWidget {
  final List<OpinionArticle> articles;
  const _OpinionGrid({required this.articles});

  @override
  Widget build(BuildContext context) {
    return _Container(
      padding: const EdgeInsets.fromLTRB(48, 48, 48, 80),
      maxWidth: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const horizontalGap = 48.0;
          const verticalGap = 56.0;
          final isWide = constraints.maxWidth >= 1000;
          final itemWidth = isWide
              ? (constraints.maxWidth - horizontalGap) / 2
              : constraints.maxWidth;

          return Wrap(
            spacing: isWide ? horizontalGap : 0,
            runSpacing: verticalGap,
            children: [
              for (final article in articles)
                SizedBox(
                  width: itemWidth,
                  child: _OpinionGridCard(article: article),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _OpinionGridCard extends StatelessWidget {
  final OpinionArticle article;
  const _OpinionGridCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            child: Image.network(
              article.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(color: const Color(0xFFE8E8E8));
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFFE8E8E8),
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_outlined, size: 40, color: Color(0xFFB0B0B0)),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          article.date,
          style: GoogleFonts.mulish(
            textStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF7C7C7C),
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          article.title,
          style: GoogleFonts.playfairDisplay(
            textStyle: const TextStyle(
              color: Color(0xFF262626),
              fontWeight: FontWeight.w600,
              fontSize: 32,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _ReadMoreLink(onTap: () {}),
      ],
    );
  }
}

class _ReadMoreLink extends StatelessWidget {
  final VoidCallback onTap;
  const _ReadMoreLink({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        'Lire Plus',
        style: GoogleFonts.mulish(
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            color: kaalisPrimary,
          ),
        ),
      ),
    );
  }
}

class _PortraitHero extends StatelessWidget {
  final PortraitFeature feature;
  const _PortraitHero({required this.feature});

  @override
  Widget build(BuildContext context) {
    return _Container(
      padding: const EdgeInsets.fromLTRB(48, 64, 48, 60),
      maxWidth: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Builder(
            builder: (context) {
              final width = MediaQuery.of(context).size.width;
              double fontSize = 84;
              if (width < 640) {
                fontSize = 44;
              } else if (width < 1000) {
                fontSize = 64;
              }
              return Text(
                feature.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  textStyle: TextStyle(
                    color: const Color(0xFF131313),
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize,
                    height: 1,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 520;
              if (isNarrow) {
                return Column(
                  children: [
                    Text(
                      feature.date,
                      style: GoogleFonts.mulish(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: kaalisMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ReadMoreLink(onTap: () {}),
                  ],
                );
              }

              return Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        feature.date,
                        style: GoogleFonts.mulish(
                          textStyle: const TextStyle(
                            fontSize: 12,
                            color: kaalisMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _ReadMoreLink(onTap: () {}),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              child: _PortraitImage(
                url: feature.imageUrl,
                grayscale: feature.grayscale,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PortraitSplit extends StatelessWidget {
  final PortraitFeature feature;
  const _PortraitSplit({required this.feature});

  @override
  Widget build(BuildContext context) {
    return _Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      maxWidth: double.infinity,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(width: 2, color: kaalisBorder)),
        ),
        padding: const EdgeInsets.fromLTRB(0, 38, 0, 70),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 1000;
            final gap = isWide ? 56.0 : 24.0;

            final aspect = isWide ? 4 / 3 : 16 / 9;
            final image = ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              child: AspectRatio(
                aspectRatio: aspect,
                child: _PortraitImage(url: feature.imageUrl, grayscale: feature.grayscale),
              ),
            );

            final textBlock = _PortraitDetails(feature: feature);

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 11, child: image),
                  SizedBox(width: gap),
                  Expanded(flex: 9, child: textBlock),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                image,
                SizedBox(height: gap),
                textBlock,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PortraitDetails extends StatelessWidget {
  final PortraitFeature feature;
  const _PortraitDetails({required this.feature});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double titleSize = 44;
    if (width < 640) {
      titleSize = 32;
    } else if (width < 1000) {
      titleSize = 36;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            feature.date,
            style: GoogleFonts.mulish(
              textStyle: const TextStyle(
                fontSize: 12,
                color: kaalisMuted,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            feature.title,
            style: GoogleFonts.playfairDisplay(
              textStyle: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.w600,
                height: 1.1,
                color: const Color(0xFF1F1F1F),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _ReadMoreLink(onTap: () {}),
        ],
      ),
    );
  }
}

class _PortraitImage extends StatelessWidget {
  final String url;
  final bool grayscale;
  const _PortraitImage({required this.url, this.grayscale = false});

  @override
  Widget build(BuildContext context) {
    Widget image = Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(color: const Color(0xFFE8E8E8));
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFFE8E8E8),
          alignment: Alignment.center,
          child: const Icon(Icons.person_outline, size: 48, color: Color(0xFFB0B0B0)),
        );
      },
    );

    if (grayscale) {
      image = ColorFiltered(colorFilter: const ColorFilter.matrix(_grayscaleMatrix), child: image);
    }

    return image;
  }
}

class SectionPortrait extends StatefulWidget {
  const SectionPortrait({super.key});

  @override
  State<SectionPortrait> createState() => _SectionPortraitState();
}

class _SectionPortraitState extends State<SectionPortrait> {
  late final Future<PortraitData> _future = PortraitRepository.instance.fetch();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PortraitData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _AsyncSectionLoading(message: 'Chargement des portraits…');
        }
        if (snapshot.hasError) {
          return const _SectionPlaceholder(
            title: 'Portrait',
            message: 'Impossible d’afficher les portraits pour le moment.',
          );
        }
        final data = snapshot.data;
        if (data == null || data.spotlights.isEmpty) {
          return const _SectionPlaceholder(
            title: 'Portrait',
            message: 'Aucun portrait disponible pour le moment.',
          );
        }
        final cards = data.spotlights.take(2).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHead(title: 'Portrait', action: 'Voir Plus', showDivider: false),
            const SizedBox(height: _sectionSpacing),
            _Container(
              padding: const EdgeInsets.fromLTRB(48, 64, 48, 56),
              maxWidth: double.infinity,
              child: LayoutBuilder(
                builder: (context, c) {
                  const gap = 32.0;
                  final isWide = c.maxWidth >= 900 && cards.length >= 2;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildSpotlightCard(cards[0], wide: true, isPrimary: true)),
                        const SizedBox(width: gap),
                        Expanded(child: _buildSpotlightCard(cards[1], wide: true, isPrimary: false)),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSpotlightCard(cards[0], wide: false, isPrimary: true),
                      if (cards.length > 1) ...[
                        const SizedBox(height: gap),
                        _buildSpotlightCard(cards[1], wide: false, isPrimary: false),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSpotlightCard(PortraitSpotlight data, {required bool wide, required bool isPrimary}) {
    final alignment = isPrimary ? Alignment.centerLeft : Alignment.bottomLeft;
    final EdgeInsets overlayPadding = isPrimary
        ? const EdgeInsets.symmetric(horizontal: 26)
        : const EdgeInsets.fromLTRB(26, 0, 26, 26);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: wide ? 16 / 10 : 4 / 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                data.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFFEFEFEF)),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x33000000), Color(0xAA000000)],
                  ),
                ),
              ),
              Padding(
                padding: overlayPadding,
                child: Align(
                  alignment: alignment,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.title,
                        style: GoogleFonts.playfairDisplay(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data.subtitle,
                        style: GoogleFonts.mulish(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          data.date,
          style: GoogleFonts.mulish(
            textStyle: const TextStyle(
              fontSize: 12,
              color: kaalisMuted,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }
}

class SectionChoix extends StatelessWidget {
  const SectionChoix({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHead(title: 'Nos Choix du Moment', showDivider: false),
          const SizedBox(height: _sectionSpacing),
        _Container(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          maxWidth: double.infinity,
          child: LayoutBuilder(
            builder: (context, c) {
              final isWide = c.maxWidth > 980;

              if (isWide) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Expanded(flex: 3, child: _ChoixLargeCard()),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              _ChoixSmallCard(),
                              SizedBox(height: 5),
                              _ChoixSmallCard(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _ChoixLargeCard(),
                  SizedBox(height: 24),
                  _ChoixSmallCard(),
                  SizedBox(height: 24),
                  _ChoixSmallCard(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ChoixLargeCard extends StatelessWidget {
  const _ChoixLargeCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 5 / 4,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(color: const Color(0xFFEFEFEF)),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Titre',
                      style: GoogleFonts.playfairDisplay(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          '22/04/2030',
          style: GoogleFonts.mulish(
            textStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9A9A9A),
              letterSpacing: 0.4,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Description',
          style: GoogleFonts.mulish(
            textStyle: const TextStyle(
              fontSize: 15,
              color: Color(0xFF6A6A6A),
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChoixSmallCard extends StatelessWidget {
  const _ChoixSmallCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFEFEFEF),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              '22/04/2030',
              style: GoogleFonts.mulish(
                textStyle: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9A9A9A),
                  letterSpacing: 0.4,
                ),
              ),
            ),
            const Spacer(),
            const Spacer(),
            Text(
              'Titre',
              style: GoogleFonts.playfairDisplay(
                textStyle: const TextStyle(
                  color: kaalisPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SectionLieux extends StatelessWidget {
  const SectionLieux({super.key});

  @override
  Widget build(BuildContext context) {
    final hero = _lieuxArticles.first;
    final others = _lieuxArticles.skip(1).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LieuxHero(article: hero),
        const SizedBox(height: _sectionSpacing),
        _LieuxGrid(articles: others),
      ],
    );
  }
}

class _LieuxHero extends StatelessWidget {
  final _LieuxArticle article;
  const _LieuxHero({required this.article});

  @override
  Widget build(BuildContext context) {
    return _Container(
      padding: const EdgeInsets.fromLTRB(48, 72, 48, 40),
      maxWidth: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Builder(
            builder: (context) {
              final width = MediaQuery.of(context).size.width;
              double fontSize = 84;
              if (width < 640) {
                fontSize = 44;
              } else if (width < 1000) {
                fontSize = 64;
              }
              return Text(
                article.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  textStyle: TextStyle(
                    color: const Color(0xFF131313),
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize,
                    height: 1,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 520;
              if (isNarrow) {
                return Column(
                  children: [
                    Text(
                      article.date,
                      style: GoogleFonts.mulish(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: kaalisMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ReadMoreLink(onTap: () {}),
                  ],
                );
              }

              return Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        article.date,
                        style: GoogleFonts.mulish(
                          textStyle: const TextStyle(
                            fontSize: 12,
                            color: kaalisMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _ReadMoreLink(onTap: () {}),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              child: Image.network(
                article.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(color: const Color(0xFFE8E8E8));
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFE8E8E8),
                    alignment: Alignment.center,
                    child: const Icon(Icons.place_outlined, size: 48, color: Color(0xFFB0B0B0)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LieuxGrid extends StatelessWidget {
  final List<_LieuxArticle> articles;
  const _LieuxGrid({required this.articles});

  @override
  Widget build(BuildContext context) {
    return _Container(
      padding: const EdgeInsets.fromLTRB(48, 56, 48, 80),
      maxWidth: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const horizontalGap = 48.0;
          const verticalGap = 56.0;
          final isWide = constraints.maxWidth >= 1000;
          final itemWidth = isWide
              ? (constraints.maxWidth - horizontalGap) / 2
              : constraints.maxWidth;

          return Wrap(
            spacing: isWide ? horizontalGap : 0,
            runSpacing: verticalGap,
            children: [
              for (final article in articles)
                SizedBox(
                  width: itemWidth,
                  child: _LieuxGridCard(article: article),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _LieuxGridCard extends StatelessWidget {
  final _LieuxArticle article;
  const _LieuxGridCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            child: Image.network(
              article.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(color: const Color(0xFFE8E8E8));
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFFE8E8E8),
                  alignment: Alignment.center,
                  child: const Icon(Icons.place_outlined, size: 40, color: Color(0xFFB0B0B0)),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          article.date,
          style: GoogleFonts.mulish(
            textStyle: const TextStyle(
              fontSize: 12,
              color: kaalisMuted,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          article.title,
          style: GoogleFonts.playfairDisplay(
            textStyle: const TextStyle(
              color: Color(0xFF262626),
              fontWeight: FontWeight.w600,
              fontSize: 32,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _ReadMoreLink(onTap: () {}),
      ],
    );
  }
}

class _StyleHero extends StatelessWidget {
  final _StyleArticle article;
  const _StyleHero({required this.article});

  @override
  Widget build(BuildContext context) {
    return _Container(
      padding: const EdgeInsets.fromLTRB(48, 72, 48, 48),
      maxWidth: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Builder(
            builder: (context) {
              final width = MediaQuery.of(context).size.width;
              double fontSize = 84;
              if (width < 640) {
                fontSize = 44;
              } else if (width < 1000) {
                fontSize = 64;
              }
              return Text(
                article.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  textStyle: TextStyle(
                    color: const Color(0xFF131313),
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize,
                    height: 1,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 520;
              if (isNarrow) {
                return Column(
                  children: [
                    Text(
                      article.date,
                      style: GoogleFonts.mulish(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: kaalisMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ReadMoreLink(onTap: () {}),
                  ],
                );
              }

              return Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        article.date,
                        style: GoogleFonts.mulish(
                          textStyle: const TextStyle(
                            fontSize: 12,
                            color: kaalisMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _ReadMoreLink(onTap: () {}),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              child: Image.network(
                article.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(color: const Color(0xFFE8E8E8));
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFE8E8E8),
                    alignment: Alignment.center,
                    child: const Icon(Icons.local_mall_outlined, size: 48, color: Color(0xFFB0B0B0)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StyleGrid extends StatelessWidget {
  final List<_StyleArticle> articles;
  const _StyleGrid({required this.articles});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1000;
        if (!isWide) {
          return _Container(
            padding: const EdgeInsets.fromLTRB(48, 28, 48, 60),
            maxWidth: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < articles.length; i++) ...[
                  if (i > 0) const SizedBox(height: 56),
                  _StyleGridCard(article: articles[i]),
                ],
              ],
            ),
          );
        }

        final columnA = <Widget>[];
        final columnB = <Widget>[];

        for (var i = 0; i < articles.length; i++) {
          final card = _StyleGridCard(article: articles[i]);
          Widget wrapped = card;
          if (i.isOdd) {
            wrapped = Padding(
              padding: const EdgeInsets.only(top: 80),
              child: card,
            );
          } else if (i % 4 == 2) {
            wrapped = Padding(
              padding: const EdgeInsets.only(top: 20),
              child: card,
            );
          }

          if (i.isEven) {
            columnA.add(wrapped);
          } else {
            columnB.add(wrapped);
          }
        }

        return _Container(
          padding: const EdgeInsets.fromLTRB(48, 28, 48, 60),
          maxWidth: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < columnA.length; i++) ...[
                      if (i > 0) const SizedBox(height: 56),
                      columnA[i],
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < columnB.length; i++) ...[
                      if (i > 0) const SizedBox(height: 56),
                      columnB[i],
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StyleGridCard extends StatelessWidget {
  final _StyleArticle article;
  const _StyleGridCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            child: Image.network(
              article.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(color: const Color(0xFFE8E8E8));
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFFE8E8E8),
                  alignment: Alignment.center,
                  child: const Icon(Icons.local_mall_outlined, size: 40, color: Color(0xFFB0B0B0)),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          article.date,
          style: GoogleFonts.mulish(
            textStyle: const TextStyle(
              fontSize: 12,
              color: kaalisMuted,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          article.title,
          style: GoogleFonts.playfairDisplay(
            textStyle: const TextStyle(
              color: Color(0xFF262626),
              fontWeight: FontWeight.w600,
              fontSize: 32,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _ReadMoreLink(onTap: () {}),
      ],
    );
  }
}

class _CommunityEvent {
  final String title;
  final String date;
  final String time;
  final String description;
  final String imageUrl;
  final String heroImageUrl;
  const _CommunityEvent({
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    required this.imageUrl,
    this.heroImageUrl = '',
  });
}

const _communityEvents = [
  _CommunityEvent(
    title: '\u00C9v\u00E9nement Mis en\nAvant',
    date: 'Vendredi 2 janvier 2026',
    time: '10:00 \u2013 12:30',
    description: 'Un rendez-vous pour rencontrer toute la communaut\u00E9 Kaalis, partager vos projets et vous inspirer.',
    imageUrl: 'https://images.unsplash.com/photo-1526318472351-c75fcf070305?q=80&w=1600&auto=format&fit=crop',
    heroImageUrl: 'https://images.unsplash.com/photo-1526318472351-c75fcf070305?q=80&w=1600&auto=format&fit=crop',
  ),
  _CommunityEvent(
    title: '\u00C9v\u00E9nement 2',
    date: 'Vendredi 2 janvier 2026',
    time: '00:30 \u2013 01:30',
    description: 'Votre prochaine destination pour un s\u00E9jour \u00E0 Gagnoa. Face \u00E0 l\u2019int\u00E9r\u00EAt grandissant envers les f\u00EAtes discos...',
    imageUrl: 'https://picsum.photos/seed/event-1/1200/800',
  ),
  _CommunityEvent(
    title: '\u00C9v\u00E9nement 3',
    date: 'Vendredi 2 janvier 2026',
    time: '00:30 \u2013 01:30',
    description: 'D\u00E9couvrez les coulisses du prochain Pop-Up Kaalis, rencontrez les cr\u00E9ateurs et profitez d\u2019exp\u00E9riences exclusives.',
    imageUrl: 'https://picsum.photos/seed/event-2/1200/800',
  ),
];



class SectionStyle extends StatelessWidget {
  const SectionStyle({super.key});

  @override
  Widget build(BuildContext context) {
    final hero = _styleArticles.first;
    final others = _styleArticles.skip(1).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StyleHero(article: hero),
        const SizedBox(height: _sectionSpacing),
        _StyleGrid(articles: others),
      ],
    );
  }
}

class SectionCommunity extends StatelessWidget {
  const SectionCommunity({super.key});

  @override
  Widget build(BuildContext context) {
    final hero = _communityEvents.first;
    final others = _communityEvents.skip(1).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CommunityHero(event: hero),
        const SizedBox(height: _sectionSpacing),
        _CommunityList(events: others),
      ],
    );
  }
}

class _CommunityHero extends StatelessWidget {
  final _CommunityEvent event;
  const _CommunityHero({required this.event});

  static const double _minHeight = 560.0;

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.of(context).size.height;
    final heroHeight = math.max(viewportHeight, _minHeight);

    return Container(
      height: heroHeight,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(event.heroImageUrl.isNotEmpty ? event.heroImageUrl : event.imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.08), BlendMode.srcOver),
        ),
        border: const Border(bottom: BorderSide(width: 2, color: kaalisBorder)),
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xF5FFFFFF),
              Color(0x66FFFFFF),
              Color(0x00FFFFFF),
            ],
            stops: [0.0, 0.35, 1.0],
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: _Container(
            padding: const EdgeInsets.fromLTRB(48, 120, 48, 36),
            maxWidth: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                double fontSize = 84;
                if (width < 640) {
                  fontSize = 44;
                } else if (width < 1000) {
                  fontSize = 64;
                }
                return Text(
                  event.title,
                  style: GoogleFonts.playfairDisplay(
                    textStyle: TextStyle(
                      color: kaalisPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize,
                      height: 0.98,
                      shadows: const [
                        Shadow(color: Color(0x66FFFFFF), offset: Offset(0, 1), blurRadius: 0),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CommunityList extends StatelessWidget {
  final List<_CommunityEvent> events;
  const _CommunityList({required this.events});

  @override
  Widget build(BuildContext context) {
    return _Container(
      padding: const EdgeInsets.fromLTRB(48, 28, 48, 70),
      maxWidth: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < events.length; i++) ...[
            if (i > 0) const SizedBox(height: 48),
            _CommunityItem(event: events[i]),
          ],
        ],
      ),
    );
  }
}

class _CommunityItem extends StatelessWidget {
  final _CommunityEvent event;
  const _CommunityItem({required this.event});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1000;
        final gap = isWide ? 48.0 : 20.0;

        final media = ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          child: AspectRatio(
            aspectRatio: isWide ? 16 / 10 : 16 / 9,
            child: Image.network(
              event.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(color: const Color(0xFFE8E8E8));
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFFE8E8E8),
                  alignment: Alignment.center,
                  child: const Icon(Icons.event, size: 48, color: Color(0xFFB0B0B0)),
                );
              },
            ),
          ),
        );

        final body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: GoogleFonts.playfairDisplay(
                textStyle: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111111),
                  height: 1.02,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${event.date}\n${event.time}',
              style: GoogleFonts.mulish(
                textStyle: const TextStyle(
                  fontSize: 12,
                  color: kaalisMuted,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              event.description,
              style: GoogleFonts.mulish(
                textStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6A6A6A),
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _CommunityButton(onTap: () {}),
          ],
        );

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 11, child: media),
              SizedBox(width: gap),
              Expanded(flex: 9, child: body),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            media,
            SizedBox(height: gap),
            body,
          ],
        );
      },
    );
  }
}

class _CommunityButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CommunityButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: _CommunityButtonContent(),
      ),
    );
  }
}

class _CommunityButtonContent extends StatefulWidget {
  @override
  State<_CommunityButtonContent> createState() => _CommunityButtonContentState();
}

class _CommunityButtonContentState extends State<_CommunityButtonContent> {
  bool _hovering = false;

  void _setHover(bool value) {
    if (_hovering == value) return;
    setState(() => _hovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final background = _hovering ? Colors.white : kaalisPrimary;
    final foreground = _hovering ? kaalisPrimary : Colors.white;

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: kaalisPrimary, width: 2),
        ),
        child: Text(
          'Voir l\u2019\u00E9v\u00E9nement \u279C',
          style: GoogleFonts.mulish(
            textStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: foreground,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionPlaceholder extends StatelessWidget {
  final String title;
  final String message;
  const _SectionPlaceholder({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHead(title: title, showDivider: false),
        const SizedBox(height: _sectionSpacing),
        _Container(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            message,
            style: GoogleFonts.mulish(
              textStyle: const TextStyle(
                fontSize: 16,
                color: kaalisText,
                height: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NewsletterDrawer extends StatefulWidget {
  final NewsletterController controller;
  const NewsletterDrawer({required this.controller});

  @override
  State<NewsletterDrawer> createState() => _NewsletterDrawerState();
}

class _NewsletterDrawerState extends State<NewsletterDrawer> {
  final FocusScopeNode _focusScope = FocusScopeNode(debugLabel: 'newsletter_scope');
  final FocusNode _panelFocus = FocusNode(debugLabel: 'newsletter_panel');
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  late final TapGestureRecognizer _moreRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    _moreRecognizer.onTap = () {};
    widget.controller.addListener(_handleControllerChange);
  }

  @override
  void didUpdateWidget(covariant NewsletterDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleControllerChange);
      widget.controller.addListener(_handleControllerChange);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChange);
    _focusScope.dispose();
    _panelFocus.dispose();
    _emailController.dispose();
    _moreRecognizer.dispose();
    super.dispose();
  }

  void _handleControllerChange() {
    if (widget.controller.isOpen) {
      Future.microtask(() {
        if (mounted) {
          _focusScope.requestFocus(_panelFocus);
        }
      });
    } else {
      _focusScope.unfocus();
    }
    setState(() {});
  }

  void _submit(BuildContext context) {
    final form = _formKey.currentState;
    if (form == null) return;
    final emailValid = form.validate();
    final genderValid = _selectedGender != null;
    if (!emailValid || !genderValid) {
      if (!genderValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Merci de choisir un genre.')),
        );
      }
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Merci ! Vous \u00EAtes inscrit\u00B7e \u00E0 la newsletter Kaalis.')),
    );
    form.reset();
    _emailController.clear();
    setState(() => _selectedGender = null);
    widget.controller.close();
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = widget.controller.isOpen;
    final mediaWidth = MediaQuery.of(context).size.width;
    final panelWidth = math.min(560.0, mediaWidth * 0.92);

    return IgnorePointer(
      ignoring: !isOpen,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isOpen ? 1 : 0,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: widget.controller.close,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.45),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: AnimatedSlide(
                offset: Offset(isOpen ? 0 : 1, 0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                child: SizedBox(
                  width: panelWidth,
                  child: Shortcuts(
                    shortcuts: <LogicalKeySet, Intent>{
                      LogicalKeySet(LogicalKeyboardKey.escape): const _CloseNewsletterIntent(),
                    },
                    child: Actions(
                      actions: {
                        _CloseNewsletterIntent: CallbackAction<_CloseNewsletterIntent>(
                          onInvoke: (_) {
                            widget.controller.close();
                            return null;
                          },
                        ),
                      },
                  child: FocusScope(
                    node: _focusScope,
                    child: Focus(
                      focusNode: _panelFocus,
                      child: Overlay(
                        initialEntries: [
                          OverlayEntry(
                            builder: (context) => Material(
                              color: newsletterBg,
                              elevation: 16,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 56, left: 24, right: 24, bottom: 28),
                                    child: _buildContent(context),
                                  ),
                                  Positioned(
                                    top: 12,
                                    left: 12,
                                    child: IconButton(
                                      icon: const Icon(Icons.close, size: 28, color: Colors.black87),
                                      tooltip: 'Fermer l\u2019inscription',
                                      onPressed: widget.controller.close,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    _moreRecognizer.onTap = () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plus d’informations arrivent bientôt.')),
      );
    };
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rejoindre la communaut\u00E9\nKaalis',
              style: GoogleFonts.playfairDisplay(
                textStyle: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: kaalisPrimary,
                  height: 1.02,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text:
                        'Soyez les premiers inform\u00E9s des s\u00E9lections Kaalis, de nos inspirations et \u00E9v\u00E8nements. ',
                  ),
                  TextSpan(
                    text: 'En savoir plus',
                    style: const TextStyle(decoration: TextDecoration.underline),
                    recognizer: _moreRecognizer,
                  ),
                ],
              ),
              style: const TextStyle(color: newsletterText, fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 18),
            const Text(
              'Email *',
              style: TextStyle(color: newsletterText, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              decoration: InputDecoration(
                hintText: 'votre@email.com',
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0x8C000000)),
                  borderRadius: BorderRadius.circular(2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              style: const TextStyle(color: newsletterText),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) {
                  return 'Merci de renseigner un email';
                }
                final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                if (!emailRegex.hasMatch(email)) {
                  return 'Adresse email invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            const Text(
              'Genre *',
              style: TextStyle(color: newsletterText, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 420;
                return Wrap(
                  spacing: 28,
                  runSpacing: 14,
                  children: [
                    _genderOption('Mr', isNarrow),
                    _genderOption('Ms', isNarrow),
                    _genderOption('Mx', isNarrow),
                    _genderOption('NA', isNarrow, label: 'Pr\u00E9f\u00E9rer ne pas dire'),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black, width: 2),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ).copyWith(
                  overlayColor: WidgetStateProperty.all(Colors.black.withValues(alpha: 0.1)),
                ),
                onPressed: () => _submit(context),
                child: const Text('S\u2019inscrire'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _genderOption(String value, bool isNarrow, {String? label}) {
    final isSelected = _selectedGender == value;
    final displayLabel = label ?? value;
    return SizedBox(
      width: isNarrow ? double.infinity : null,
      child: InkWell(
        onTap: () => setState(() => _selectedGender = value),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(
                value: value,
                // ignore: deprecated_member_use
                groupValue: _selectedGender,
                // ignore: deprecated_member_use
                onChanged: (val) => setState(() => _selectedGender = val),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) return Colors.black;
                  return newsletterMuted.withValues(alpha: 0.8);
                }),
              ),
              const SizedBox(width: 8),
              Text(
                displayLabel,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? newsletterText : newsletterText.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CloseNewsletterIntent extends Intent {
  const _CloseNewsletterIntent();
}

class _Footer extends StatefulWidget {
  const _Footer();

  @override
  State<_Footer> createState() => _FooterState();
}

class _FooterState extends State<_Footer> {
  late final FocusNode _ctaFocus = FocusNode(debugLabel: 'psst_cta');

  @override
  void dispose() {
    _ctaFocus.dispose();
    super.dispose();
  }

  void _openNewsletter(BuildContext context) {
    NewsletterProvider.of(context).open(invoker: _ctaFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Container(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          maxWidth: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
            ],
          ),
        ),
        _Container(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          maxWidth: double.infinity,
          child: LayoutBuilder(
            builder: (context, c) {
              final isWide = c.maxWidth > 800;
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(child: _FooterCol()),
                        SizedBox(width: 40),
                        Expanded(child: _FooterSocials()),
                      ],
                    )
                  : const Column(
                      children: [
                        _FooterCol(),
                        SizedBox(height: 24),
                        _FooterSocials(),
                      ],
                    );
            },
          ),
        ),
        _Container(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          maxWidth: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 24),
              FocusableActionDetector(
                focusNode: _ctaFocus,
                shortcuts: const <ShortcutActivator, Intent>{
                  SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
                  SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
                },
                actions: {
                  ActivateIntent: CallbackAction<ActivateIntent>(
                    onInvoke: (_) {
                      _openNewsletter(context);
                      return null;
                    },
                  ),
                },
                child: _FooterBanner(onActivate: () => _openNewsletter(context)),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ],
    );
  }
}

class _FooterCol extends StatelessWidget {
  const _FooterCol();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _FootLabel('Communaut\u00E9'),
        SizedBox(height: 8),
        _FooterLink(label: 'FAQ', route: _Routes.faq),
        SizedBox(height: 12),
        _FooterLink(label: 'Politique de confidentialit\u00E9', route: _Routes.privacy),
        SizedBox(height: 12),
        _FooterLink(label: 'Partenariat', route: _Routes.partners),
        SizedBox(height: 32),
        _FootLabel('Abidjan, C\u00F4te d\'Ivoire (Fran\u00E7ais)'),
      ],
    );
  }
}

class _FooterSocials extends StatelessWidget {
  const _FooterSocials();

  @override
  Widget build(BuildContext context) {
    const socials = [
      (Icons.music_note, 'TikTok', _Routes.socialTiktok),
      (Icons.facebook, 'Facebook', _Routes.socialFacebook),
      (Icons.camera_alt_outlined, 'Instagram', _Routes.socialInstagram),
      (Icons.alternate_email, 'X', _Routes.socialX),
      (Icons.play_circle_fill, 'Youtube', _Routes.socialYoutube),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < socials.length; i++) ...[
          _FooterLink(label: socials[i].$2, route: socials[i].$3, icon: socials[i].$1),
          if (i < socials.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _FooterBanner extends StatefulWidget {
  final VoidCallback onActivate;
  const _FooterBanner({required this.onActivate});

  @override
  State<_FooterBanner> createState() => _FooterBannerState();
}

class _FooterBannerState extends State<_FooterBanner> {
  bool _hovering = false;

  void _setHover(bool value) {
    if (_hovering == value) return;
    setState(() => _hovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final bannerText = _hovering ? 'Clique ici' : 'Viens voir un truc';
    final background = _hovering
        ? Color.lerp(kaalisPrimary, Colors.white, 0.12)!
        : kaalisPrimary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTap: widget.onActivate,
        behavior: HitTestBehavior.opaque,
        child: Semantics(
          button: true,
          label: 'Ouvrir l’inscription à la newsletter Kaalis',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: background,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    final offsetTween = Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    );
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: offsetTween.animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    bannerText,
                    key: ValueKey(bannerText),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                const Text('+', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FootLabel extends StatelessWidget {
  final String text;
  const _FootLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: Color(0xFF6C6C6C)));
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final String route;
  final IconData? icon;
  const _FooterLink({required this.label, required this.route, this.icon});

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.mulish(
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: icon != null ? 15 : 14,
        color: kaalisPrimary,
        decoration: TextDecoration.underline,
        decorationColor: kaalisPrimary.withValues(alpha: 0.5),
      ),
    );

    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(route),
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: kaalisPrimary),
              const SizedBox(width: 10),
            ],
            Flexible(child: Text(label, style: textStyle)),
          ],
        ),
      ),
    );
  }
}
