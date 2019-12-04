<?php

$formConfigFile = file_get_contents("rd-mailform.config.json");
$formConfig = json_decode($formConfigFile, true);

date_default_timezone_set('Etc/UTC');

try {
    require './phpmailer/PHPMailerAutoload.php';

    $recipients = $formConfig['recipientEmail'];

    preg_match_all("/([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)/", $recipients, $addresses, PREG_OFFSET_CAPTURE);

    if (!count($addresses[0])) {
        die('MF001');
    }

    function getRemoteIPAddress() {
        if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
            return $_SERVER['HTTP_CLIENT_IP'];

        } else if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            return $_SERVER['HTTP_X_FORWARDED_FOR'];
        }
        return $_SERVER['REMOTE_ADDR'];
    }

    if (preg_match('/^(127\.|192\.168\.)/', getRemoteIPAddress())) {
        die('MF002');
    }

    $template = file_get_contents('rd-mailform.tpl');

    if (isset($_POST['form-type'])) {
        switch ($_POST['form-type']){
            case 'contact':
                $subject = 'A message from your site visitor';
                break;
            case 'subscribe':
                $subject = 'Subscribe request';
                break;
            case 'order':
                $subject = 'Order request';
                break;
            default:
                $subject = 'A message from your site visitor';
                break;
        }
    }else{
        die('MF004');
    }

    if (isset($_POST['first_name'])) {
        $template = str_replace(
            array("<!-- #{FirstNameState} -->", "<!-- #{FirstNameDescription} -->"),
            array("First Name:", $_POST['first_name']),
            $template);
    }
    if (isset($_POST['last_name'])) {
        $template = str_replace(
            array("<!-- #{LastNameState} -->", "<!-- #{LastNameDescription} -->"),
            array("Last Name:", $_POST['last_name']),
            $template);
    }
    if (isset($_POST['email'])) {
        $template = str_replace(
            array("<!-- #{FromState} -->", "<!-- #{FromEmail} -->"),
            array("Email:", $_POST['email']),
            $template);
    }
    if (isset($_POST['phone'])) {
        $template = str_replace(
            array("<!-- #{phoneState} -->", "<!-- #{PhoneDescription} -->"),
            array("Phone:", $_POST['phone']),
            $template);
    }
    if (isset($_POST['subject'])) {
        $template = str_replace(
            array("<!-- #{SujectState} -->", "<!-- #{SujectDescription} -->"),
            array("Subject:", $_POST['subject']),
            $template);
    }
    if (isset($_POST['experience'])) {
        $template = str_replace(
            array("<!-- #{ExperienceState} -->", "<!-- #{ExperienceDescription} -->"),
            array("Experience:", $_POST['experience']),
            $template);
    }    
    if (isset($_POST['country'])) {
        $template = str_replace(
            array("<!-- #{CountryState} -->", "<!-- #{CountryDescription} -->"),
            array("Country:", $_POST['country']),
            $template);
    }
    if (isset($_POST['vacancy'])) {
        $template = str_replace(
            array("<!-- #{VacancyState} -->", "<!-- #{VacancyDescription} -->"),
            array("Vacancy:", $_POST['vacancy']),
            $template);
    }    
    if (isset($_POST['education'])) {
        $template = str_replace(
            array("<!-- #{EducationState} -->", "<!-- #{EducationDescription} -->"),
            array("Education:", $_POST['education']),
            $template);
    }    
    if (isset($_POST['city'])) {
        $template = str_replace(
            array("<!-- #{CityState} -->", "<!-- #{CityDescription} -->"),
            array("City:", $_POST['city']),
            $template);
    }
    if (isset($_POST['state'])) {
        $template = str_replace(
            array("<!-- #{State} -->", "<!-- #{StateDescription} -->"),
            array("State:", $_POST['state']),
            $template);
    } 
    if (isset($_POST['message'])) {
        $template = str_replace(
            array("<!-- #{MessageState} -->", "<!-- #{MessageDescription} -->"),
            array("Message:", $_POST['message']),
            $template);
    }

    preg_match("/(<!-- #{BeginInfo} -->)(.|\n)+(<!-- #{EndInfo} -->)/", $template, $tmp, PREG_OFFSET_CAPTURE);
    foreach ($_POST as $key => $value) {
       // if ($key != "email" && $key != "message" && $key != "phone" && $key != "name" && $key != "subject"  && $key != "form-type" && $key != "g-recaptcha-response" && !empty($value)){
        if ($key != "email" && $key != "message" && $key != "phone" && $key != "first_name" && $key != "last_name" && $key != "subject" && $key != "state" && $key != "country" && $key != "city" && $key != "vacancy" && $key != "upload" && $key != "form-type" && $key != "g-recaptcha-response" && !empty($value)){
            $info = str_replace(
                array("<!-- #{BeginInfo} -->", "<!-- #{InfoState} -->", "<!-- #{InfoDescription} -->"),
                array("", ucfirst($key) . ':', $value),
                $tmp[0][0]);

            $template = str_replace("<!-- #{EndInfo} -->", $info, $template);
        }
    }

    $template = str_replace(
        array("<!-- #{Subject} -->", "<!-- #{SiteName} -->"),
        array($subject, $_SERVER['SERVER_NAME']),
        $template);

    $mail = new PHPMailer();


    if ($formConfig['useSmtp']) {
        //Tell PHPMailer to use SMTP
        $mail->isSMTP();

        //Enable SMTP debugging
        // 0 = off (for production use)
        // 1 = client messages
        // 2 = client and server messages
        $mail->SMTPDebug = 0;

        $mail->Debugoutput = 'html';

        // Set the hostname of the mail server
        $mail->Host = $formConfig['host'];

        // Set the SMTP port number - likely to be 25, 465 or 587
        $mail->Port = $formConfig['port'];

        // Whether to use SMTP authentication
        $mail->SMTPAuth = true;
        $mail->SMTPSecure = "ssl";

        // Username to use for SMTP authentication
        $mail->Username = $formConfig['username'];

        // Password to use for SMTP authentication
        $mail->Password = $formConfig['password'];
    }

    $mail->From = $addresses[0][0][0];

    # Attach file
    if (isset($_FILES['upload']) &&
        $_FILES['upload']['error'] == UPLOAD_ERR_OK) {
        $mail->AddAttachment($_FILES['upload']['tmp_name'],
            $_FILES['upload']['name']);
    }

    if (isset($_POST['first_name'])){
        $mail->FromName = $_POST['first_name'];
    }else{
        $mail->FromName = "Site Visitor";
    }

    foreach ($addresses[0] as $key => $value) {
        $mail->addAddress($value[0]);
    }

    $mail->CharSet = 'utf-8';
    $mail->Subject = $subject;
    $mail->MsgHTML($template);
    //$mail->send();

   if($mail->send()){
        die('MF000');
    }
    else
    {
        die('MF002');   
    }

    die('MF000');
} catch (phpmailerException $e) {
    die('MF254');
} catch (Exception $e) {
    die('MF255');
}