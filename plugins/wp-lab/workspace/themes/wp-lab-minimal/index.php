<?php
?><!doctype html>
<html <?php language_attributes(); ?>>
<head>
    <meta charset="<?php bloginfo('charset'); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>
<?php wp_body_open(); ?>
<main class="site-main">
    <div class="site-panel">
        <h1><?php esc_html_e('WP Lab listo', 'wp-lab-minimal'); ?></h1>
        <p><?php esc_html_e('Este tema minimo mantiene visible el sitio local para probar plugins y temas desde el primer arranque.', 'wp-lab-minimal'); ?></p>
    </div>
</main>
<?php wp_footer(); ?>
</body>
</html>
