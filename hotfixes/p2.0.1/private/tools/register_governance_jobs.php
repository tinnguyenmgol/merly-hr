<?php
declare(strict_types=1);

$root = getenv('MERLY_ROOT') ?: dirname(__DIR__, 3);
$root = rtrim($root, '/');

$file = $root . '/private/jobs/jobs_config.php';
$out = $file . '.p2tmp';

if (!is_file($file)) {
    fwrite(STDERR, "P2 JOB REGISTER FAIL: missing jobs_config.php\n");
    exit(1);
}

$cfg = require $file;
if (!is_array($cfg) || !isset($cfg['jobs']) || !is_array($cfg['jobs'])) {
    fwrite(STDERR, "P2 JOB REGISTER FAIL: invalid jobs config\n");
    exit(2);
}

$php = '/usr/bin/php ';

$cfg['jobs']['governance_guard'] = [
    'enabled' => true,
    'description' => 'Payroll lock/source governance + audit guard',
    'schedule' => ['type' => 'every_minutes', 'interval' => 10],
    'steps' => [[
        'name' => 'governance_guard',
        'command' => $php . $root . '/private/cron/governance_guard.php',
        'required' => true,
        'retry' => true,
        'retry_attempts' => 3,
    ]],
];

$cfg['jobs']['governance_config_backup'] = [
    'enabled' => true,
    'description' => 'Daily configuration snapshot',
    'schedule' => ['type' => 'daily_times', 'times' => ['03:20']],
    'steps' => [[
        'name' => 'governance_config_backup',
        'command' => $php . $root . '/private/cron/governance_config_backup.php',
        'required' => true,
        'retry' => true,
        'retry_attempts' => 3,
    ]],
];

$content = "<?php\ndeclare(strict_types=1);\n\nreturn " . var_export($cfg, true) . ";\n";

if (file_put_contents($out, $content, LOCK_EX) === false) {
    fwrite(STDERR, "P2 JOB REGISTER FAIL: cannot write temp\n");
    exit(3);
}

echo "P2 JOBS PREPARED governance_guard=10m config_backup=03:20\n";
