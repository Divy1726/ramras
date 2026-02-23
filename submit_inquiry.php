<?php
if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    die("Invalid request");
}
$name = $_POST["name"] ?? '';
$email = $_POST["email"] ?? '';
$phone = $_POST["phone"] ?? '';
$subject = $_POST["subject"] ?? 'Inquiry';
$message = $_POST["message"] ?? '';

if (empty($name) || empty($message) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
    die("Form data missing or invalid.");
}

$to = 'info@ramras.co.in';
$email_subject = "New Inquiry: $subject";
$email_body = "Name: $name\n" . "Email: $email\n" . "Phone: $phone\n" . "Subject: $subject\n\n" . "Message:\n$message";
$headers = "From: RAMRAS Website <info@ramras.co.in>\r\n";
$headers .= "Reply-To: $name <$email>\r\n";
$headers .= "X-Mailer: PHP/" . phpversion();

if (mail($to, $email_subject, $email_body, $headers)) {
    header("Location: inquiry?status=success");
    exit;
} else {
    header("Location: inquiry?status=error");
    exit;
}
?>