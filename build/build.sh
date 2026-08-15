#!/bin/sh
# Rebuild index.html from the template + embedded assets.
# Run from the project root (Documents/Portfolio):  sh build/build.sh
cd "$(dirname "$0")/.." || exit 1
perl -pe '
BEGIN{
  sub slurp { local $/; open my $f, "<", $_[0] or die $_[0]; my $d = <$f>; $d =~ s/\s+//g; $d }
  %m = (
    BRICOLAGE => slurp("build/fonts/bricolage.woff2.b64"),
    INSTRUMENT=> slurp("build/fonts/instrument.woff2.b64"),
    MONO400   => slurp("build/fonts/plexmono400.woff2.b64"),
    MONO500   => slurp("build/fonts/plexmono500.woff2.b64"),
    PORTOSHOT => slurp("build/shots/portofoli-home.jpg.b64"),
    GOLDTHUMB => slurp("build/shots/gold-thumb-small.jpg.b64"),
    ARIASHOT  => slurp("build/shots/aria.jpg.b64"),
    FATURASHOT=> slurp("build/shots/fatura.jpg.b64"),
  );
}
s/__B64_(\w+)__/$m{$1}/ge;
' build/portfolio-template.html > build/.tmp.html || exit 1
{ printf '<!doctype html>\n<html lang="en">\n<meta charset="utf-8">\n'; cat build/.tmp.html; printf '</html>\n'; } > index.html
rm -f build/.tmp.html
echo "Built index.html ($(wc -c < index.html) bytes)"
