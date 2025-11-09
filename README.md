# Kaalis Flutter

Magazine web Flutter inspiré d’un univers éditorial haut de gamme (Opinion, Portrait, Lieux, Style, Communauté) avec un bloc Partenariats relié à une API JSON et un modal de contact.

## Prérequis

- Flutter (canal **stable**, 3.x)
- Chrome ou tout navigateur compatible pour les tests web

```bash
flutter --version
```

## Commandes clés

| Action | Commande |
| --- | --- |
| Installer | `flutter pub get` |
| Analyse | `flutter analyze` |
| Tests | `flutter test` |
| Run web | `flutter run -d chrome` |
| Build web | `flutter build web --release` |

## Workflow recommandé

1. Créer une issue (feature ou bug) via les templates fournis.
2. Créer une branche (`feat/...`, `fix/...`).
3. Développer + `flutter analyze && flutter test`.
4. Ouvrir une PR ⟶ CI `flutter-ci.yml`.
5. Merge ⟶ `deploy-web.yml` publie automatiquement sur GitHub Pages (source = GitHub Actions dans *Settings → Pages*).

## CI/CD

- `.github/workflows/flutter-ci.yml` : analyse + tests sur chaque push/PR (`master`/`main`).
- `.github/workflows/deploy-web.yml` : build web release + déploiement GitHub Pages.

## API Contenu (Opinion / Portrait / Partenariats)

| Zone | JSON source | Client Flutter | Notes |
| --- | --- | --- | --- |
| Opinion (home + page dédiée) | `data/opinion.json` | `lib/services/opinion_api.dart` | Home cards + liste d’articles |
| Portrait (home + page dédiée) | `data/portrait.json` | `lib/services/portrait_api.dart` | Spotlights + features |
| Partenariats | `data/partners.json` | `lib/services/partners_api.dart` | Opportunités + modal |

Chaque service pointe par défaut sur l’URL GitHub Raw correspondante (`https://raw.githubusercontent.com/DmK4real/KaalisMag/master/data/...`).  
Tu peux éditer les fichiers JSON ou remplacer les endpoints dans les clients pour cibler ton propre backend/CMS.

## Modal Partenariats

- Tous les boutons « Contacter l’équipe » ouvrent le formulaire (overlay rouille, touche Esc, bouton ✕).
- Validation minimale sur chaque champ + `SnackBar` de confirmation.

## Idées prochaines

- Tests widget ciblant chaque section.
- Contenu dynamique pour les autres pages (Opinion, Portrait, etc.).
- Internationalisation FR/EN avec `flutter_localizations`.

Bon build ✨
