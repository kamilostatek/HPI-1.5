#!/usr/bin/env bash
# HaierPi 1.4.5 Alpha13 -> 1.5 Smart Adaptive R5 Energia
set -Eeuo pipefail
umask 077

SERVICE="haier.service"
ROOT="${HAIERPI_ROOT:-}"
ROOT="${ROOT%/}"
BASE_DIR="${ROOT}/opt/haier"
CONFIG="${ROOT}/opt/config.ini"
BACKUP_DIR="${ROOT}/var/backups/haierpi"
DROPIN="${ROOT}/etc/systemd/system/haier.service.d/20-haierpi-15.conf"
PYTHON="${BASE_DIR}/env/bin/python"
ARCHIVE_NAME="HaierPi_1.5_alpha.tar.gz"
EXPECTED_ARCHIVE_SHA256="ca29df7961f9710955b626b89b248c48b5f49f83baa33ce236caca3fd4b7ffa3"
ARCHIVE_URL="${HAIERPI_ARCHIVE_URL:-https://raw.githubusercontent.com/kamilostatek/HPI-1.5/main/HaierPi_1.5_alpha.tar.gz}"
# Uzupelniane przez validation/package/build_release.py dla WSZYSTKICH plikow runtime.
# Szablon bez manifestu odmawia instalacji przed zatrzymaniem uslugi.
EXPECTED_RUNTIME_JSON='{"HPi/GPIO.py":"188bc603ad445ed236e6090b85123a6bf3babaaf047d475b39bfdd14b9e6d0af","HPi/__init__.py":"52388348e137e3919e51ad29fcb747ca2286cc3cf7141b4b16d349a87ba72fac","PyHaier/Get3way.py":"8e68ca56e1ea755049470be22d75fb41edd37a34f24895f294510993e40d2a20","PyHaier/GetAntifreeze.py":"077574e4f128dd364eb23e00ff5624937e19e287a3442a18328059e6d934f8fa","PyHaier/GetArchError.py":"f192292fe316dfd1e94f8637a3444bd37980479184e7347ff042003c069949ad","PyHaier/GetCHTemp.py":"2734217113beeadbb74f885d0b5b21327baab768e3808dac337416afe3e7fdf3","PyHaier/GetCompInfo.py":"54e851660be482595f64ab302bcb0d30ea75d876d1d797b78594fd7b0a174609","PyHaier/GetDHWCompensation.py":"27ebf0972deda5d677836f669771fc28f3f638880adf662d23950579b0691d99","PyHaier/GetDHWCurTemp.py":"6611d75556ecb990e20e64d10f619c0d30070f62ca8e535741b2614e07ab255d","PyHaier/GetDHWTemp.py":"2d7acaab0bc78c5d57da15c444be0de68881b66f9176372ec647271d4065baec","PyHaier/GetDefrost.py":"a772c74949e4644ba0890d1433f24a3fc71d0ba13ada9285da749f31a8382a45","PyHaier/GetEEVLevel.py":"798117103bdfd76b4c3e188e3af0c9cc24d5ab6388d1a601d29a16967f836cba","PyHaier/GetError.py":"8695338f2f10665f109b3511f17482cb27d935c1194f05762b72802b9c2a2df3","PyHaier/GetFanRpm.py":"0bc97e2fa656c31ca3a25665260448579fc4dd4ee14642d68ecb635a6573ad57","PyHaier/GetFirmware.py":"c862b0b15813d262bbaac57b230694bb5fa36c582530594a9d872c9507676de7","PyHaier/GetHeater.py":"a5079736a71086a2b1d280b7a9d1fa70d878198f3f70f15c9e94555bcf2f0c13","PyHaier/GetLastError.py":"fb956adeb7e8452275b4e8d0f8f9bd109dd672e7be9a93baaddfc7c240c58d5f","PyHaier/GetMode.py":"b9d6ea18793aa5343fc62bfcc7b18c54080cd945e4a9be536700585a036b4aed","PyHaier/GetPdPs.py":"6cf2c1be67c8f483c43718ce2aadb4dcb2e2a2a8f151dc0a084475b3d024516c","PyHaier/GetPump.py":"edb90e98573c8630a9c98130b38b0776b76c1c892100f71b9751418fd6c32a3e","PyHaier/GetState.py":"9bee1431daff7db7db3ddca8f16a2f90c439b59724e36a1a3bd4e138fd549351","PyHaier/GetTSatPd.py":"1309a483e7a5999dc16ca4d672c4f0a51777cf11196053e2c49fb58ac35a1dbc","PyHaier/GetTSatPs.py":"69ea7b4493a2a2d8d598d10bd89e244dbc62159decc33cf96adb428fdd004467","PyHaier/GetTao.py":"631d090aa5c294ddd3c10a1e64c20fa3bdaa17195afee4413ee6e3e15256c32d","PyHaier/GetTdTs.py":"415a1daf2a1caa60b53414ff80db1e644a44dafb8fb40b2bba3fbd0bcb7e6411","PyHaier/GetTdef.py":"1b2ab85ded123db8ed8fc707a9bf5d10d697949c7b168d4b3284ff3a386b5fa1","PyHaier/GetTempCompensation.py":"80c8491d68bbe17c232f394ccfe90f790717bf0dfdc9d33433c11c5ca9589390","PyHaier/GetThiTho.py":"98dc002396a5682e2425d85f2fe08bb1489ae32b9a766fe17855199c66ede275","PyHaier/GetTwiTwo.py":"80a1baa7c34552b190447754242c98c3a0d61748bc6763a3415fbb0c3959b821","PyHaier/SetCHTemp.py":"4cfb485b6d70427db92469191cdb04964ad664e738c1d573fbbae293c8dd82b7","PyHaier/SetDHWCompensation.py":"09c5bd6b6347ceadd1dfb62bff9abca00eaa526594ac032eaf8ad1839d686eca","PyHaier/SetDHWTemp.py":"84b70f335c25a5afe967a0a4f601fcdf29a97b414fafe06a8a4da95a8f4d914c","PyHaier/SetHeater.py":"aeb6685221415a310a649196c249ac16c81dc999960caa86aaabac26f34afea5","PyHaier/SetMode.py":"5286a553e00f0c18f07f8dfe7202ca4e8a97ddab4ec130148c51f8df58d9bfb4","PyHaier/SetPump.py":"58895575444315f9643371a80d81587916a3b7afbd297bb9b4ff3ebe3617c4c8","PyHaier/SetState.py":"7c207ce3bb62ee20acba45acde5240bc9c4946ff1d1dcda0f631a5c62990f0a2","PyHaier/SetTempCompensation.py":"daf076be60af1140e583b82e5bdeb190969e8697b49782ef3dd0a18ff04bc11d","PyHaier/__init__.py":"2a01fb1ca913b5c9a88fa974eec715bd4c8fe970696f682359c4810b7662bc23","compressor_cycles.py":"ebdc02eac8452815be8544b234ea833987ecc90137c945b1f32aaeca04d278d0","energy_meter.py":"25cf94d2ca7690f66aafe79dbc9e3ae1962c79b126bcf2ac01fb8fa8bc14ab36","haierpi_maintenance.py":"c4fb2988979f65346ed29530e5bf45b0e802604da8a82d32c44c05d9914a89ab","main.py":"f6a1600f1950747ac34524d81cc32ce3d64abdfb04edfde734071711a1e52637","smart_anti_adapter.py":"9ad5502887855e70adb38a1662f62359cba106ac137cab6f82133c97d18af743","smart_anti_drive.py":"c6d591d24006e6d50b5d255dd9ec4e5eef2db09e9e15867739cce7f2fe9af03c","smart_anti_onoff.py":"ec29678824a18f813255e48eecbb31f30b02c06bbdf4745bb591a903ab22d013","static/bootstrap-icons.woff":"bb1de989b83970f6f4e54de1cd974c5cba55b73582da5e1b225a6d0edf029483","static/bootstrap-icons.woff2":"476adf42b40325098fcfa8b36ab3e769186bb4f6ce6a249753e2e1a9c22bf99e","static/compressor_cycles.js":"fe25671b25511f86fb63858c75054c58c9fdab8876a79ccd4cc03f07a2b73142","static/custom.js":"7b86e4117c47a2eb5f23327f94e61a0b28fb3ebf866c3a0ad817fa0f24973892","static/dark.css":"6e0212455d51e32f275c960d54454f3c522cdea62ac78f4c746a68f57efaf9c7","static/flags/en.svg":"452183ba6f1dbbbb18cd85fb66c9cbf751b1c13a805416d9ce6eb8496da71e8a","static/flags/nl.svg":"c62d9b88d2ff9e6476120325e86d79d4cb9c4ddbe6254d6d96bc4fa14f6bfd2b","static/flags/pl.svg":"32abd89415c7bbdef7b1ea61ab9f0adb70736fc0ad2c3261b2ace061ac167c48","static/font.css":"af25ec129fd0a85f5b6656efe8d6fb4ba854d1abdc9e2cd2e426e5c1e493fcdf","static/hpi_status.js":"b60956c879e1a60b8ff63bd8434ed5f13628aa41ea0e6b7b59dea122d2527274","static/icon512_maskable.png":"fa1a428da471c84b6bcb320168e3afdc06f7303b1c2453bce1818f6935834533","static/icon512_rounded.png":"760397cd6a954dee64a5f5ce027594661b914b8bc1759153bf2b484b36f3cae1","static/jquery.dark.schedule.css":"d78426f42b3c01891398123cb49823ae38efaae7bc4d16ce65c52e7b3028eb1a","static/jquery.light.schedule.css":"ce753d1a80cb9744114d9a3520b33ac6d2f49defb558e00af9cd4f2a8661929f","static/jquery.schedule2.js":"9104d3217645861514e366f387f6c9dc1f7869c885850c5bfa85bec1aa7d7ecf","static/light.css":"b166631d0898f5fbe179400ea31aeccf0f56a61977cea7d56b3d6464a12fa2df","static/locales/en/translation.json":"c0857619ed3466d4e1bd366a7977e128b0b99f8aefb24a1a27beca55d8662483","static/locales/nl/translation.json":"5f9742145c0f521e1f142dd17f11e489fed627486e6d6b4ff33f985889f65839","static/locales/pl/translation.json":"ade0835d9ba6f92c6990e205cdd1fc8259ce9ee2e062b36b85047df00662cf67","static/longtouch.js":"5460761802214c68572e428c8fbca07f5d86fc8ee5baad08fbe7029900db6f54","static/manifest.json":"9a831efa138a9d1fadea9d985df1b771113fcc337d412e1b9a73399e1688b067","static/person.svg":"4ab39c9c7e2b1d1d678435548fb999626d25ea5f8d395a341c4f6971e51a2ff9","static/scripts.js":"6ac43cb4707f44a23cdf23a1c1aebb82863f523012f7ffc05ad10fc4b7dc220e","static/socket.js":"6119571809bcce7a4316b0352b1a7424c7b8c7760d6c31bbfc38d832cbf88490","static/styles.css":"abb9231a3ea1db0ce346b44e9c307bee1403ab7e5c87dcba44731055475706ac","static/sweetalert2.min.js":"943ca531cc40261ab2aae143ea52cdf28d889c89b37ea4a65c8647f8604dcc90","static/vendor/LICENSES.md":"63397b0b7b27f92fff63db587ba9f23fd37b345837ff45830355337ee57491bb","static/vendor/bootstrap.bundle-5.3.6.min.js":"cb789b7cec81aa580177e1b3c0561011539974d243d3a1de0d78a1a278015cab","static/vendor/jquery-3.6.0.min.js":"ff1523fb7389539c84c65aba19260648793bb4f5e29329d2ee8804bc37a3fe6e","static/vendor/jquery-ui-1.13.3.min.js":"b30d2234d5e63896d085816e0bd385da43a50f929029ed72e657c19f80bd4a38","static/welcome.js":"cd5711e2c65891553ffcd465df3e520813a87d43539f51c5e52012e4df27f162","templates/base.html":"5e11dfacd14d1222c99a113c58f28612cf5717451bfb47b208b891ee2458a2bb","templates/charts.html":"7500cc4e0a01da490fc368acc0edfa6d6537c10eebc756ab3a04011b9641ae1e","templates/energy.html":"b5c240eb67d4ca25482f5d0a75b5d418e86fd4cade44283df511bd9a4e022258","templates/index.html":"69f2f4d81060017f7a625a1611bc3997d56ae780efefcaee05d2a5e7fce9f3fd","templates/login.html":"e6f5346987a57c45b23d3776c84ffe8c71178931b5cd397c5a3d15a628074bfe","templates/parameters.html":"9238e590376e0eee62fb86edbecf34d618f25e88213b03d1566e8a4337ad0372","templates/restore.html":"dacf1155401674a3b5b9b3ac9e4444cf328a02ba6e93820bdd091adf3f18137f","templates/scheduler.html":"bc37a50b33402121f0118d3ad02a1c5dcc96414ee3ce8cb90659cf31b15c5efe","templates/settings.html":"5ad4f1f852229b8df856c072b71a0a2eb1a74d82643573afd6e383f67b8f9485","templates/weblog.html":"ee9ed3bd49bc666831bd5bec8ef2e794832a4133b36d1c3587e5d771e92ff74c"}'

msg() { printf '%s\n' "$*"; }
fail() { msg "BLAD: $*" >&2; exit 1; }
[[ "${EUID}" -eq 0 ]] || fail "Uruchom instalator jako root."
(( $# <= 1 )) || fail "Uzycie: bash install.sh [sciezka_do_archiwum]"

SYSTEMCTL="$(command -v systemctl || true)"
[[ -n "$SYSTEMCTL" ]] || fail "Nie znaleziono systemctl."
[[ -f "$BASE_DIR/main.py" && -d "$BASE_DIR/static" && -d "$BASE_DIR/templates" ]] || fail "Brak istniejacej instalacji w $BASE_DIR."
[[ -f "$BASE_DIR/users.json" && -f "$CONFIG" ]] || fail "Brak users.json lub config.ini."
[[ -x "$PYTHON" ]] || fail "Brak interpretera Python istniejacej instalacji: $PYTHON"
"$SYSTEMCTL" cat "$SERVICE" >/dev/null || fail "Nie znaleziono uslugi $SERVICE."

PYHAIER_DIR="$("$PYTHON" -c 'import sysconfig; print(sysconfig.get_path("purelib"))')/PyHaier"
[[ "$PYHAIER_DIR" == "$BASE_DIR/env/"* && -d "$PYHAIER_DIR" && ! -L "$PYHAIER_DIR" ]] || fail "Nieprawidlowa lokalizacja PyHaier: $PYHAIER_DIR"

WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/haierpi-15.XXXXXXXX")"
STAGE="$WORK_DIR/stage"
mkdir -p "$STAGE"
STOPPED=0
CHANGED=0
UPDATED_DROPIN=0
OLD_DROPIN=0
BACKUP=""

finish() {
    local rc=$?
    trap - EXIT
    if (( rc != 0 )); then
        msg "Instalacja nie powiodla sie (kod $rc)."
        if (( STOPPED )); then
            if (( CHANGED )); then
                msg "Przywracam poprzednie pliki z kopii..."
                rm -rf -- "$PYHAIER_DIR"
                "$SYSTEMCTL" stop "$SERVICE" >/dev/null 2>&1 || true
                rm -rf -- "$BASE_DIR/HPi" "$BASE_DIR/static" "$BASE_DIR/templates" "$BASE_DIR/main.py" "$BASE_DIR/haierpi_maintenance.py" "$BASE_DIR/smart_anti_onoff.py" "$BASE_DIR/smart_anti_drive.py" "$BASE_DIR/smart_anti_adapter.py" "$BASE_DIR/compressor_cycles.py" "$BASE_DIR/energy_meter.py" "$BASE_DIR/__pycache__"
                if [[ -n "$BACKUP" && -f "$BACKUP" ]]; then
                    tar -xzf "$BACKUP" -C "${ROOT}/opt" || msg "UWAGA: Przywracanie kopii nie powiodlo sie: $BACKUP"
                fi
            fi
            if (( UPDATED_DROPIN )); then
                if (( OLD_DROPIN )); then
                    cp -a "$WORK_DIR/previous-dropin.conf" "$DROPIN" || true
                else
                    rm -f -- "$DROPIN"
                fi
                "$SYSTEMCTL" daemon-reload || true
            fi
            "$SYSTEMCTL" start "$SERVICE" || msg "UWAGA: Nie udalo sie uruchomic poprzedniej uslugi."
        fi
    fi
    rm -rf -- "$WORK_DIR"
    exit "$rc"
}
trap finish EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

# 1. Znajdz lub pobierz archiwum, zanim zatrzymasz dzialajaca usluge.
ARCHIVE=""
if (( $# == 1 )); then
    [[ -f "$1" ]] || fail "Nie ma archiwum: $1"
    ARCHIVE="$1"
elif [[ "${BASH_SOURCE[0]:-}" != "" && -f "${BASH_SOURCE[0]:-}" ]]; then
    SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"
    for candidate in "$PWD/$ARCHIVE_NAME" "${SCRIPT_DIR:-/nonexistent}/$ARCHIVE_NAME" "${ROOT}/root/$ARCHIVE_NAME"; do
        if [[ -f "$candidate" ]]; then ARCHIVE="$candidate"; break; fi
    done
fi

if [[ -z "$ARCHIVE" && -z "$ARCHIVE_URL" ]]; then
    fail "Nie znaleziono lokalnego archiwum $ARCHIVE_NAME. Przekaz sciezke do pliku."
fi
if [[ -z "$ARCHIVE" ]]; then
    command -v curl >/dev/null 2>&1 || fail "Brak curl do pobrania paczki."
    msg "Pobieram $ARCHIVE_NAME..."
    ARCHIVE="$WORK_DIR/$ARCHIVE_NAME"
    curl --fail --location --silent --show-error --retry 3 --connect-timeout 20 --max-time 180 \
        --output "$ARCHIVE" "$ARCHIVE_URL" || fail "Nie udalo sie pobrac archiwum z: $ARCHIVE_URL"
else
    msg "Uzywam lokalnego archiwum: $ARCHIVE"
fi

printf '%s  %s\n' "$EXPECTED_ARCHIVE_SHA256" "$ARCHIVE" | sha256sum -c - || fail "Nieprawidlowa suma SHA-256 archiwum."

# 2. Bezpieczne rozpakowanie TYLKO plikow programu (bez instrukcji, testow, tools, env).
#    Dodatkowo sprawdzenie wersji kodu, aby nie wgrac przypadkiem starszej paczki.
"$PYTHON" - "$ARCHIVE" "$STAGE" "$EXPECTED_RUNTIME_JSON" <<'PY'
import ast
import hashlib
import json
import pathlib
import sys
import tarfile

archive, stage, expected_json = sys.argv[1:]
try:
    expected = json.loads(expected_json)
except (TypeError, ValueError):
    raise SystemExit('Instalator nie zawiera manifestu wydania. Uzyj kompletnego instalatora R5 z paczki.')
if not isinstance(expected, dict) or not expected:
    raise SystemExit('Nieprawidlowy manifest wydania.')
root_python = ('main.py', 'haierpi_maintenance.py', 'smart_anti_onoff.py',
               'smart_anti_drive.py', 'smart_anti_adapter.py', 'compressor_cycles.py', 'energy_meter.py')
base = pathlib.Path(stage)
required = {
    'main.py', 'haierpi_maintenance.py', 'smart_anti_onoff.py',
    'smart_anti_drive.py', 'smart_anti_adapter.py', 'compressor_cycles.py', 'energy_meter.py',
    'templates/base.html', 'templates/settings.html', 'templates/energy.html',
    'static/custom.js', 'static/socket.js', 'static/hpi_status.js',
    'static/vendor/LICENSES.md', 'PyHaier/__init__.py', 'HPi/GPIO.py', 'HPi/__init__.py',
}
if not required.issubset(expected):
    raise SystemExit('Manifest nie zawiera wszystkich wymaganych plikow R5.')
found = set()
total = 0
with tarfile.open(archive, 'r:gz') as tf:
    for item in tf:
        parts = pathlib.PurePosixPath(item.name).parts
        if not parts or item.name.startswith('/') or '..' in parts or '\\' in item.name:
            raise SystemExit('Niebezpieczna sciezka w archiwum: ' + item.name)
        if not item.isfile() and not item.isdir():
            raise SystemExit('Niedozwolony typ pliku w archiwum: ' + item.name)
        if item.isdir():
            continue
        rel = '/'.join(parts[1:] if parts[0] == 'HaierPi_1.5' else parts)
        if rel not in root_python and not rel.startswith(('static/', 'templates/', 'PyHaier/', 'HPi/')):
            raise SystemExit('Niedozwolony plik runtime: ' + rel)
        # README i opisy zmian nie sa instalowane. Noty licencyjne bibliotek pozostaja.
        if rel.endswith(('.md', '.rst', '.txt')) and rel != 'static/vendor/LICENSES.md':
            raise SystemExit('Plik dokumentacji poza paczka runtime: ' + rel)
        if not rel or rel.startswith('/') or '/..' in rel:
            raise SystemExit('Nieprawidlowa sciezka docelowa: ' + rel)
        if item.size > 15 * 1024 * 1024:
            raise SystemExit('Plik przekracza dozwolony rozmiar: ' + rel)
        total += item.size
        if total > 50 * 1024 * 1024:
            raise SystemExit('Archiwum zawiera zbyt duzo danych')
        if rel in found:
            raise SystemExit('Powtorzona sciezka w archiwum: ' + rel)
        if rel not in expected:
            raise SystemExit('Plik spoza manifestu wydania: ' + rel)
        found.add(rel)
        dest = base / rel
        dest.parent.mkdir(mode=0o755, parents=True, exist_ok=True)
        src = tf.extractfile(item)
        if src is None:
            raise SystemExit('Nie mozna odczytac pliku: ' + rel)
        with src, dest.open('wb') as target:
            while True:
                chunk = src.read(1024 * 1024)
                if not chunk:
                    break
                target.write(chunk)
        dest.chmod(0o644)

missing = set(expected) - found
if missing:
    raise SystemExit('W paczce brakuje: ' + ', '.join(sorted(missing)))
for rel, expected_hash in sorted(expected.items()):
    actual = hashlib.sha256((base / rel).read_bytes()).hexdigest()
    if actual != expected_hash:
        raise SystemExit('Zla wersja pliku ' + rel + ': ' + actual)
for rel in (r for r in expected if r.endswith('.py')):
    ast.parse((base / rel).read_bytes(), filename=rel)
print('HaierPi 1.5 Smart Adaptive R5 Energia Menu Tooltipy: {} plikow, sumy SHA-256 i skladnia OK'.format(len(found)))
PY

# 3. Przygotuj konfiguracje bez zmiany aktualnie uzywanego pliku.
#    Zachowujemy wartosci, komentarze i dane logowania; migrujemy tylko
#    usuniete opcje Smart i jego nowy bezwzgledny limit kompensacji A03.
DHW_USE="${HAIERPI_DHW_USE:-}"
if ! "$PYTHON" - "$CONFIG" <<'PY_CHECK_DHW'
import re, sys
section = None
with open(sys.argv[1], encoding='utf-8-sig') as fh:
    for line in fh:
        m = re.match(r'^\s*\[([^]]+)\]', line)
        if m:
            section = m.group(1).strip().upper()
        if section == 'SETTINGS' and re.match(r'^\s*dhwuse\s*=', line, re.I):
            sys.exit(0)
sys.exit(1)
PY_CHECK_DHW
then
    if [[ -z "$DHW_USE" ]]; then
        if [[ -r /dev/tty ]]; then
            read -r -p 'Czy korzystasz z CWU? [t/n]: ' answer </dev/tty
            case "$answer" in [Tt]*) DHW_USE=1;; [Nn]*) DHW_USE=0;; *) fail "Odpowiedz t lub n.";; esac
        else
            fail "Brak dhwuse. Uruchom interaktywnie albo ustaw HAIERPI_DHW_USE=0 lub 1."
        fi
    fi
    [[ "$DHW_USE" == 0 || "$DHW_USE" == 1 ]] || fail "HAIERPI_DHW_USE musi wynosic 0 lub 1."
fi

"$PYTHON" - "$CONFIG" "$WORK_DIR/config.ini" "$DHW_USE" <<'PY'
from collections import OrderedDict
import math
import re
import sys

source, target, dhw_use = sys.argv[1:]
with open(source, 'r', encoding='utf-8-sig', newline='') as fh:
    original = fh.read()
if '\r\n' in original:
    newline = '\r\n'
else:
    newline = '\n'

section_re = re.compile(r'^\s*\[([^]]+)\]\s*(?:[#;].*)?$')
key_re = re.compile(r'^\s*([^=:#\s][^=:]*?)\s*[=:]')
smart_keys = {}
section = None
for line in original.splitlines():
    match = section_re.match(line)
    if match:
        section = match.group(1).strip().upper()
    elif section == 'SETTINGS':
        match = key_re.match(line)
        if match and not line.lstrip().startswith(('#', ';')):
            key = match.group(1).strip().casefold()
            if key.startswith('smart_anti_onoff'):
                smart_keys[key] = line[match.end():].strip()

max_key = 'smart_anti_onoff_max_compensation'
old_max_key = 'smart_anti_onoff_max_offset'
old_sim_key = 'smart_anti_onoff_dry_run'
obsolete_keys = {old_max_key, old_sim_key} | {
    'smart_anti_onoff_' + mode + '_limit_hz'
    for mode in ('quiet', 'eco', 'turbo', 'flimit')
}
# The old offset cannot be added to an unknown manual A03 setting. Keep its
# numeric value as the new absolute ceiling; explicit new-format values win.
max_default = '1.0'
if max_key not in smart_keys and old_max_key in smart_keys:
    try:
        previous = float(smart_keys[old_max_key].replace(',', '.'))
    except (TypeError, ValueError, OverflowError):
        previous = float('nan')
    if (math.isfinite(previous) and 0.5 <= previous <= 3.0
            and previous * 2 == round(previous * 2)):
        max_default = '{:.1f}'.format(previous)

# Removing simulation must not silently start pump writes for a formerly
# observing installation. max_compensation identifies an already migrated
# config, so later upgrades preserve its enabled state without a dry_run key.
was_simulation = (smart_keys.get(old_sim_key) != '0'
                  if old_sim_key in smart_keys else max_key not in smart_keys)
disable_old_simulation = (smart_keys.get('smart_anti_onoff') == '1'
                          and was_simulation)

entries = OrderedDict([
    ('MAIN', OrderedDict([('ui_font', 'inter')])),
    ('SETTINGS', OrderedDict([
        ('dhwuse', dhw_use or '0'),
        ('zone_frost_enable', '0'), ('zone_frost_temp', '-5'), ('zone_frost_mode', 'quiet'),
        ('zone_warm_enable', '0'), ('zone_warm_temp', '10'), ('zone_warm_mode', 'quiet_flimit'),
        ('emergency_intemp', '20.0'), ('dhwtemp', 'builtin'),
        ('dhw_heater_assist_below_temp', '10'), ('dhw_heater_assist_enable', '0'),
        ('anti_legionella_temp', '60.0'), ('anti_legionella_enable', '0'),
        ('dhwnolimit_mode', 'turbo'), ('direct_inside_settemp', '22.0'),
        ('antifreeze_custom_enable', '0'), ('antifreeze_custom_outtemp', '1'),
        ('antifreeze_custom_twi', '4'), ('antifreeze_custom_two', '4'),
        ('antifreeze_custom_runtime_min', '0.5'), ('service_test_duration_s', '30'),
        ('thermostat_on', '1'), ('heatingcurve_last', 'manual'),
        ('restore_state_on_boot', '1'),
        ('intemp_builtin_offset', '0.0'),
        ('outtemp_builtin_offset', '0.0'),
        ('tao_offset', '0.0'),
        ('smart_anti_onoff', '0'),
        ('smart_anti_onoff_interval_min', '5'),
        (max_key, max_default),
        ('smart_anti_onoff_a03_live', '0'),
        ('smart_anti_onoff_frost_bypass', '0'),
        ('smart_anti_onoff_frost_temp', '-10.0'),
    ])),
    ('HOMEASSISTANT', OrderedDict([('dhwsensor', '')])),
    ('MQTT', OrderedDict([('snapshot_interval_s', '30')])),
    ('ENERGY', OrderedDict([
        ('mode', 'estimate'),
        ('pump_w', ''),
        ('heater_w', ''),
        ('standby_w', ''),
        ('crankcase_w', ''),
        ('crank_on_c', ''),
        ('crank_off_c', ''),
        ('ha_entity', ''),
        ('price_kwh', ''),
    ])),
])
sections_present = set()
current = None
seen = set()
result = []
added = []
removed = set()

def flush_section():
    if current in entries:
        for key, default in entries[current].items():
            if key.casefold() not in seen:
                if result and not result[-1].endswith(('\r', '\n')):
                    result.append(newline)
                result.append('{} = {}{}'.format(key, default, newline))
                added.append('{}.{}'.format(current, key))

for line in original.splitlines(keepends=True):
    match = section_re.match(line.rstrip('\r\n'))
    if match:
        flush_section()
        current = match.group(1).strip().upper()
        if current in sections_present:
            raise SystemExit('Powtorzona sekcja w config.ini: ' + current)
        sections_present.add(current)
        seen = set()
    elif current is not None:
        match_key = key_re.match(line)
        if match_key and not line.lstrip().startswith(('#', ';')):
            key = match_key.group(1).strip().casefold()
            if current == 'SETTINGS' and key in obsolete_keys:
                removed.add(key)
                continue
            seen.add(key)
            if (current == 'SETTINGS' and key == 'smart_anti_onoff'
                    and disable_old_simulation):
                # Keep the original key spelling, delimiter and indentation.
                whitespace = re.match(r'[ \t]*', line[match_key.end():]).group(0)
                ending = '\r\n' if line.endswith('\r\n') else '\n' if line.endswith('\n') else ''
                line = line[:match_key.end()] + whitespace + '0' + ending
    result.append(line)
flush_section()
missing_sections = set(entries) - sections_present
# MAIN and SETTINGS are fundamental for Alpha13. Optional sections may not
# exist on older installations; create them without changing existing fields.
fundamental = {'MAIN', 'SETTINGS'}
if fundamental & missing_sections:
    raise SystemExit('Brak podstawowej sekcji config.ini: ' + ', '.join(sorted(fundamental & missing_sections)))
for section_name in ('HOMEASSISTANT', 'MQTT', 'ENERGY'):
    if section_name in missing_sections:
        if result and not result[-1].endswith(('\r', '\n')):
            result.append(newline)
        result.append(newline + '[{}]'.format(section_name) + newline)
        for key, default in entries[section_name].items():
            result.append('{} = {}{}'.format(key, default, newline))
            added.append('{}.{}'.format(section_name, key))

# Fail early for invalid pre-existing options (e.g. invalid HA source settings),
# without changing valid user values.
import configparser
try:
    candidate = configparser.ConfigParser(interpolation=None)
    candidate.read_string(''.join(result))
except configparser.Error as exc:
    raise SystemExit('Niepoprawny config.ini: ' + str(exc))
energy_values = {k: candidate.get('ENERGY', k, fallback='') for k in entries['ENERGY']}
# In this migration, only syntax and basic options are checked; runtime
# validates effective options on the first load.
if energy_values['mode'] not in ('estimate', 'ha'):
    raise SystemExit('Nieprawidlowy tryb ENERGY.mode: ' + energy_values['mode'])

with open(target, 'w', encoding='utf-8', newline='') as fh:
    fh.write(''.join(result))
print('Konfiguracja: dodano {} brakujacych wpisow; usunieto {} nieuzywanych opcji Smart.'.format(len(added), len(removed)))
if max_key not in smart_keys and old_max_key in smart_keys:
    print('Smart: maksymalna kompensacja A03 = {} C (wartosc bezwzgledna).'.format(max_default))
if disable_old_simulation:
    print('Smart byl w symulacji: pozostaje wylaczony. Wlacz Smart Anty On-Off w ustawieniach, aby sterowal pompa.')
PY

# 4. Dopiero teraz zatrzymaj usluge, utworz kopie i podmien pliki.
mkdir -p "$BACKUP_DIR"
chmod 0700 "$BACKUP_DIR"
BACKUP="$BACKUP_DIR/HaierPi_przed_1.5_$(date +%Y%m%d_%H%M%S)_$$.tar.gz"
msg "Zatrzymuje $SERVICE..."
STOPPED=1
"$SYSTEMCTL" stop "$SERVICE"
msg "Tworze kopie: $BACKUP"
tar -czf "$BACKUP" -C "${ROOT}/opt" haier config.ini
tar -tzf "$BACKUP" >/dev/null || fail "Nie mozna odczytac kopii zapasowej."

if [[ -f "$DROPIN" ]]; then
    OLD_DROPIN=1
    cp -a "$DROPIN" "$WORK_DIR/previous-dropin.conf"
fi

CHANGED=1
rm -rf -- "$BASE_DIR/HPi"
cp -a "$STAGE/HPi" "$BASE_DIR/HPi"
rm -rf -- "$PYHAIER_DIR"
cp -a "$STAGE/PyHaier" "$PYHAIER_DIR"
"$PYTHON" -B -c 'import PyHaier; import pathlib, sys; assert pathlib.Path(PyHaier.__file__).resolve().parent == pathlib.Path(sys.argv[1]).resolve(); assert PyHaier.GetTao([0]*12 + [4095] + [0]*9) == -0.1' "$PYHAIER_DIR"
rm -rf -- "$BASE_DIR/static" "$BASE_DIR/templates"
cp -a "$STAGE/static" "$BASE_DIR/static"
cp -a "$STAGE/templates" "$BASE_DIR/templates"
install -m 0644 "$STAGE/main.py" "$BASE_DIR/main.py"
install -m 0644 "$STAGE/haierpi_maintenance.py" "$BASE_DIR/haierpi_maintenance.py"
install -m 0644 "$STAGE/smart_anti_onoff.py" "$BASE_DIR/smart_anti_onoff.py"
install -m 0644 "$STAGE/smart_anti_drive.py" "$BASE_DIR/smart_anti_drive.py"
install -m 0644 "$STAGE/smart_anti_adapter.py" "$BASE_DIR/smart_anti_adapter.py"
install -m 0644 "$STAGE/compressor_cycles.py" "$BASE_DIR/compressor_cycles.py"
install -m 0644 "$STAGE/energy_meter.py" "$BASE_DIR/energy_meter.py"
install -m 0600 "$WORK_DIR/config.ini" "$CONFIG"
chown root:root "$BASE_DIR/main.py" "$BASE_DIR/haierpi_maintenance.py" "$BASE_DIR/smart_anti_onoff.py" "$BASE_DIR/smart_anti_drive.py" "$BASE_DIR/smart_anti_adapter.py" "$BASE_DIR/compressor_cycles.py" "$BASE_DIR/energy_meter.py" "$CONFIG"

# Porzadki w katalogu runtime - bez naruszania env, HPi, bin, users i harmonogramow.
rm -rf -- "$BASE_DIR/docs" "$BASE_DIR/tests" "$BASE_DIR/tools" "$BASE_DIR/__pycache__"

mkdir -p "$(dirname "$DROPIN")"
UPDATED_DROPIN=1
cat > "$DROPIN" <<'EOF'
[Unit]
Description=HaierPi 1.5 - heat-pump controller

[Service]
SyslogIdentifier=HaierPi
EOF
chmod 0644 "$DROPIN"
"$SYSTEMCTL" daemon-reload
"$SYSTEMCTL" enable "$SERVICE" >/dev/null
"$SYSTEMCTL" start "$SERVICE"
sleep 3
"$SYSTEMCTL" is-active --quiet "$SERVICE" || fail "Usluga nie uruchomila sie poprawnie."

DESCRIPTION="$("$SYSTEMCTL" show "$SERVICE" -p Description 2>/dev/null || true)"
DESCRIPTION="${DESCRIPTION#Description=}"
if [[ "$DESCRIPTION" != 'HaierPi 1.5 - heat-pump controller' ]]; then
    fail "systemd nie przyjal nowej nazwy uslugi (Description=$DESCRIPTION)."
fi

STOPPED=0
CHANGED=0
msg 'HaierPi 1.5 Smart Adaptive R5 - instalacja zakonczona pomyslnie.'
msg "Kopia poprzedniej wersji: $BACKUP"
msg 'Status uslugi: active'
msg 'Po instalacji otworz panel: Zuzycie energii (ostatnia pozycja menu bocznego).'
msg 'Energia: puste moce oznaczaja wartosci domyslne algorytmu.'
