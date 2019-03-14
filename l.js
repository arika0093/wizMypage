import riot from "riot";
import sugar from "sugar";

import "./tags/html.tag";

sugar.extend();

// mount
window.addEventListener("DOMContentLoaded", () => {
	riot.mount("*")
});
