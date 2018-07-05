import "bootstrap";
import { selectTagOnClick } from "../components/wizard";
import { sliderShowValue } from "../components/slider";
import { maskCpfAndCnpj } from "../components/formMask";
import { nameFilesToUpload } from "../components/filesUpload";
import { animateNavbar } from "../components/newnavbar";
import { showPage } from "../components/homeAnimation";
import { loop } from "../components/showOnScroll";
import { presentAndDismissAlerts } from "../components/flashes";

selectTagOnClick();
sliderShowValue();
maskCpfAndCnpj();
nameFilesToUpload();
animateNavbar();
showPage();
loop();
presentAndDismissAlerts();
