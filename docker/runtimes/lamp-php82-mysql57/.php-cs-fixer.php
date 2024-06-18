<?php
$finder = PhpCsFixer\Finder::create()
    ->exclude('vendor');

$config = new PhpCsFixer\Config();
return $config->setRules([
    '@PSR12' => true,
])->setFinder($finder);
