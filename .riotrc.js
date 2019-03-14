const pug = require('pug');
const scss = require('node-sass');

module.exports = {
	template: "pug",
	style: 'scss',
	parsers: {
		html: {
			pug: (html) => {
				return pug.compile(html);
			}
		},
		css: {
			scss: function (tag, css) {
				var result = scss.renderSync({
					data: css,
					outputStyle: 'compressed',
				});
				return result.css.toString();
			}
		}
	}
};