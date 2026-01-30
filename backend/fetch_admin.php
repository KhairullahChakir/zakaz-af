<?php
$html = file_get_contents('http://127.0.0.1:8000/admin');
preg_match_all('/<link[^>]+>/', $html, $links);
preg_match_all('/<script[^>]+>/', $html, $scripts);
echo "LINKS:\n" . implode("\n", $links[0]) . "\n\n";
echo "SCRIPTS:\n" . implode("\n", $scripts[0]) . "\n";
