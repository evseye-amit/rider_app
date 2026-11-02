# App translations

`app_en.arb` is the source of message keys and placeholder metadata. The files
`app_as.arb`, `app_bn.arb`, `app_gu.arb`, `app_ml.arb`, `app_mr.arb`,
`app_or.arb`, `app_pa.arb`, `app_ta.arb`, and `app_ur.arb` currently contain
English placeholder values for most messages. The language picker heading,
helper text, and Save button are translated. Replace the remaining values while
keeping the key and any `{placeholder}` or ICU plural structure unchanged.

After editing an ARB file, run `flutter gen-l10n` from `packages/evseye_core`
and commit the changed generated file under `lib/src/l10n/generated/`.
