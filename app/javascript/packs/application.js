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
import { bindSweetAlertButton } from '../components/sweetAlert';
import { countdownClock } from '../components/countdown';
import { signDocument } from '../components/signDocument';
import { enablePopover } from "../components/popover";
import { enableTooltip } from "../components/tooltip";
import { activateWrapperLoader } from "../components/wrapperLoader";
import { activatePageLoader } from "../components/pageLoader";
import { consentModal } from "../components/consent";

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
bindSweetAlertButton();
countdownClock();
signDocument();
enablePopover();
enableTooltip();
activateWrapperLoader();
activatePageLoader();
consentModal();
