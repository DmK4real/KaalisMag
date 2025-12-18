# -*- coding: utf-8 -*-
from pathlib import Path
p=Path('lib/main.dart')
text=p.read_text(encoding='utf-8')
old="""    double titleSize = 84;
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
                  style: _ppAcma(
                    TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111111),
                      height: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Kaalis Magazine respecte votre vie privée et s’engage à protéger vos données personnelles.',
                style: _ppAcma(
                  const TextStyle(
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
                  style: _ppAcma(
                    const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                for (final paragraph in section.paragraphs) ...[
                  Text(
                    paragraph,
                    style: _ppAcma(
                      const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF3A3A3A),
                        height: 1.55,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                              const Text('• ',
                                  style: TextStyle(
                                      color: Color(0xFF3A3A3A), fontSize: 15)),
                              Expanded(
                                child: Text(
                                  bullet,
                                  style: _ppAcma(
                                    const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF3A3A3A),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
"""
new="""    double titleSize = 60;
    if (width < 1000) {
      titleSize = 48;
    }
    if (width < 640) {
      titleSize = 38;
    }

    return _Container(
      padding: const EdgeInsets.fromLTRB(48, 72, 48, 72),
      maxWidth: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Politique De Confidentialité',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: _ppAcma(
                    TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111111),
                      height: 1.05,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 780),
                  child: Text(
                    'Kaalis Magazine respecte votre vie privée et s’engage à protéger vos données personnelles.',
                    textAlign: TextAlign.center,
                    style: _ppAcma(
                      const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kaalisPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              for (final section in _sections) ...[
                Text(
                  section.title,
                  style: _ppAcma(
                    const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                for (final paragraph in section.paragraphs) ...[
                  Text(
                    paragraph,
                    style: _ppAcma(
                      const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF3A3A3A),
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (section.bullets.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 18, bottom: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final bullet in section.bullets) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ',
                                  style: TextStyle(
                                      color: Color(0xFF3A3A3A), fontSize: 15)),
                              Expanded(
                                child: Text(
                                  bullet,
                                  style: _ppAcma(
                                    const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF3A3A3A),
                                      height: 1.55,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                        ],
                      ],
                    ),
                  ),
                const SizedBox(height: 18),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
"""
if old not in text:
    raise SystemExit('old block not found')
p.write_text(text.replace(old,new),encoding='utf-8')
