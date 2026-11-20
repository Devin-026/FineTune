#!/usr/bin/env python3
"""Catch missing translations and incompatible format arguments before packaging."""
import json
from collections import Counter
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
FORMAT = re.compile(r'%(?:\d+\$)?(?:[-+ #0]*\d*(?:\.\d+)?)?(?:ll|l|h|hh|z)?[@diuoxXfFeEgGcs]')


def arguments(value):
    # Ignore escaped percent signs; compare argument types and multiplicities.
    return Counter(re.sub(r'^%\d+\$', '%', match) for match in FORMAT.findall(value.replace('%%', '')))


def validate():
    count = 0
    for name in ('Localizable', 'InfoPlist'):
        catalog = json.loads((ROOT / 'FineTune' / f'{name}.xcstrings').read_text())
        assert catalog['sourceLanguage'] == 'en'
        for key, data in catalog['strings'].items():
            unit = data['localizations']['zh-Hans']['stringUnit']
            assert unit['state'] == 'translated', key
            assert unit['value'].strip(), key
            source = key if name == 'Localizable' else data['localizations']['en']['stringUnit']['value']
            assert arguments(source) == arguments(unit['value']), f'Format argument mismatch: {key}'
            count += 1
    info = (ROOT / 'FineTune/Info.plist').read_text()
    permission_keys = json.loads((ROOT / 'FineTune/InfoPlist.xcstrings').read_text())['strings']
    assert all(f'<key>{key}</key>' in info for key in permission_keys)
    project = (ROOT / 'FineTune.xcodeproj/project.pbxproj').read_text()
    assert '"zh-Hans"' in project
    print(f'Validated {count} Simplified Chinese translations, format arguments, and permission prompts.')


if __name__ == '__main__':
    validate()
