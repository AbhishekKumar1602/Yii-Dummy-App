<?php
/* @var $this yii\web\View */

$this->title = 'Yii2 Dummy Project-Backend';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= $this->title ?></title>
    <link rel="stylesheet" href="<?= Yii::getAlias('@web') ?>/assets/css/style.css">
</head>
<body>
    <div class="main-container">
        <div class="header-container">
            <h1>Yii2 Dummy Project - Backend</h1>
        </div>
        <div class="text-container">
            <p>This Project Demonstrates Deploying a Yii2 Application on Ubuntu 22.04 with Nginx and PHP-FPM, and Creating a Docker Image for Containerized Deployment.</p>
        </div>
    </div>
</body>
</html>