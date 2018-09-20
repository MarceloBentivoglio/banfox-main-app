import "bootstrap";
import { selectTagOnClick } from "../components/wizard";
import { maskCpfCnpjCurrency } from "../components/formMask";
import { nameFilesToUpload } from "../components/filesUpload";
import { animateNavbar } from "../components/newnavbar";
import { showPage } from "../components/homeAnimation";
import { loop } from "../components/showOnScroll";
import { presentAndDismissAlerts } from "../components/flashes";
import { infiniteScrolling } from "../components/pagination";
import { showProgressbar } from "../components/mvpProgressbar";
import { addressAutocomplete } from "../components/addressAutocomplete";
import { collapseForm } from "../components/collapseForm";
import { rememberOptionsBetweenSteps } from "../components/rememberOptionsBetweenSteps"
import { showModalOnFirstAccess } from "../components/showModalOnFirstAccess"
import { operationTotalValuesAccordingToCheck, operationInAnalysisTotalValues } from "../components/operationTotalValues"


selectTagOnClick();
maskCpfCnpjCurrency();
nameFilesToUpload();
animateNavbar();
showPage();
loop();
presentAndDismissAlerts();
infiniteScrolling();
showProgressbar();
addressAutocomplete();
collapseForm();
rememberOptionsBetweenSteps();
showModalOnFirstAccess();
operationTotalValuesAccordingToCheck();
operationInAnalysisTotalValues();
