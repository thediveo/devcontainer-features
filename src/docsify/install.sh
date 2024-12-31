#!/usr/bin/env bash
set -e

DOCSIFY_SERVE_PATH="/usr/local/bin/docsify-serve"

DOCS_PATH=${DOCS_PATH:-docs}

echo "Activating feature 'docsify-cli'..."
npm install -g docsify-cli

# The fallback/default index.html file to use when the documents directory does
# not exist.
DEFAULT_INDEX_HTML=$(cat <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Fake Site</title>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <meta name="description" content="Description">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">
  <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/docsify@4/lib/themes/vue.css">
</head>
<body>
  <div id="app"></div>
  <script>
    window.$docsify = {
      name: 'fakesite',
      repo: 'fakerepo'
    }
  </script>
  <!-- Docsify v4 -->
  <script src="//cdn.jsdelivr.net/npm/docsify@4"></script>
</body>
</html>
EOF
)

# The fallback/default README.md file to use when the documents directory does
# not exist.
DEFAULT_README_MD=$(cat <<EOF
# Fake Site

> An awesome fake site test.
EOF
)

tee "$DOCSIFY_SERVE_PATH" > /dev/null \
<< EOF
#!/usr/bin/env sh
mkdir -p "${DOCS_PATH}"
if [ ! -f "${DOCS_PATH}/index.html" ]; then
    echo "${DEFAULT_INDEX_HTML}" > "${DOCS_PATH}/index.html"
    echo "${DEFAULT_README_MD}" > "${DOCS_PATH}/README.md"
fi
nohup bash -c "docsify serve -p=${PORT} -P=${LIVERELOAD_PORT} --no-open ./${DOCS_PATH} &" >/tmp/nohup.log 2>&1
EOF
chmod 0755 /usr/local/bin/docsify-serve
