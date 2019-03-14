head
	title {title}
	meta(name="viewport" content="initial-scale=1, minimum-scale=1, maximum-scale=1")
	<yield/>

body
	myPageViewer
	//-span#debug(style="position:absolute; top:0; left:0; color:#FFF; font-size: large; background: #000;") 0
	
	style.
		body {
			margin: 0;
		}
		h1,h2,h3,h4,h5,h6,p,span,blockquote,cite,li,dt,dd {
			font-family: "M PLUS 1p", "Meiryo", "Noto Sans";
			transform: rotate(0.05deg);
		}
		code {
			font-family: "Courier New", "Consolas", Monospaced;
		}
		
	script.
		import "./myPageViewer.tag";
		
		