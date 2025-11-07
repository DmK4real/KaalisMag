# Kaalis Flutter

Magazine web Flutter inspiré d’un univers éditorial haut de gamme (Opinion, Portrait, Lieux, Style, Communauté) avec bloc Partenariats et modal de contact.

## Prérequis

- Flutter (canal stable, 3.x)
- Chrome ou navigateur compatible pour les tests web

`
flutter --version
`

## Commandes clés

| Action | Commande |
| --- | --- |
| Installer | lutter pub get |
| Analyse | lutter analyze |
| Tests | lutter test |
| Run web | lutter run -d chrome |
| Build web | lutter build web --release |

## Workflow recommandé

1. Créer une issue (feature ou bug).
2. Créer une branche (eat/..., ix/...).
3. Dev + lutter analyze && flutter test.
4. Ouvrir une PR → CI lutter-ci.yml.
5. Merge → deploy-web.yml publie sur GitHub Pages.

## CI/CD

- .github/workflows/flutter-ci.yml : analyse + tests sur push/PR.
- .github/workflows/deploy-web.yml : build web & déploiement automatique (Pages).
  > Dans *Settings → Pages*, choisir **GitHub Actions** comme source.

## Modal partenaires

- Boutons « Contacter l’équipe » ouvrent un formulaire (overlay, ESC, bouton ✕).
- Validation minimale, message de confirmation via SnackBar.

## Idées prochaines

- Tests widget pour chaque section.
- Contenu dynamique (CMS/API).
- Internationalisation (FR/EN).

Bon build ✨
