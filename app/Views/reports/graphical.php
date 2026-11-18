<?php
/**
 * @var string $title
 * @var string $subtitle
 * @var string $chart_type
 * @var array $summary_data_1
 */
?>

<?= view('partial/header') ?>

<?php if (ENVIRONMENT == 'development' || get_cookie('debug') == 'true' || request()->getGet('debug') == 'true') : ?>
    <!-- inject:reportsgraphical:debug:css -->
    <link rel="stylesheet" href="resources/css/chartist-c19aedb81a.css">
    <link rel="stylesheet" href="resources/css/chartist-plugin-tooltip-2e0ec92e60.css">
    <!-- endinject -->
    <!-- inject:reportsgraphical:debug:js -->
    <script src="resources/js/chartist-8a7ecb4445.js"></script>
    <script src="resources/js/chartist-plugin-axistitle-80a1198058.js"></script>
    <script src="resources/js/chartist-plugin-barlabels-4165273742.js"></script>
    <script src="resources/js/chartist-plugin-pointlabels-0a1ab6aa4e.js"></script>
    <script src="resources/js/chartist-plugin-tooltip-116cb48831.js"></script>
    <script src="resources/js/hide_cost_profit-e8bd953ca5.js"></script>
    <!-- endinject -->
<?php else : ?>
    <!-- inject:reportsgraphical:prod:css -->
    <link rel="stylesheet" href="resources/reportsgraphical-1327e6cbee.min.css">
    <!-- endinject -->
    <!-- inject:reportsgraphical:prod:js -->
    <script src="resources/reportsgraphical-487b3febb1.min.js"></script>
    <!-- endinject -->
<?php endif; ?>

<script type="text/javascript">
    dialog_support.init("a.modal-dlg");
</script>

<div id="page_title"><?= esc($title) ?></div>

<div id="page_subtitle"><?= esc($subtitle) ?></div>

<div class="ct-chart ct-golden-section" id="chart1"></div>

<div id="toolbar">
    <div class="pull-left form-inline" role="toolbar">
        <!-- Toggle Button -->
        <button id="toggleCostProfitButton" class="btn btn-default btn-sm print_hide">
            <?php echo lang('Reports.toggle_cost_and_profit'); ?>
        </button>
    </div>
</div>

<?= view($chart_type) ?>

<div id="chart_report_summary">
    <?php foreach ($summary_data_1 as $name => $value) { ?>
        <div class="summary_row"><?= lang("Reports.$name") . ': ' . esc(to_currency($value)) ?></div>
    <?php } ?>
</div>

<?= view('partial/footer') ?>
