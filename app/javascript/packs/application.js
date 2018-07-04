import "bootstrap";
import { selectTagOnClick } from "../components/wizard";
import { sliderShowValue } from "../components/slider";
import { maskCpfAndCnpj } from "../components/formMask";
import { nameFilesToUpload } from "../components/filesUpload";
import { presentAndDismissAlerts } from "../components/flashes";

selectTagOnClick();
sliderShowValue();
maskCpfAndCnpj();
nameFilesToUpload();
presentAndDismissAlerts();
