bgimg
	bgtag(style="background-image: url( {opts.imagesrc} ); \
				background-size: {opts.width}; \
				--mwidth: {opts.maxwidth || 1092}; \
				background-position: center {opts.y}; \
				top: {opts.top}; left: {opts.left};")
	
	style(type="scss").
		
		bgimg > bgtag {
			--maxsize: 1366px;
			--maxwidth: calc( var(--maxsize) * 0.8 );
			--maxheight: var(--maxsize);
			--mwidth: var(--maxwidth);
			--top: 0;
			--left: calc( ( ( 100% - var(--mwidth) ) / 2 ) );

			display: block;
			position: absolute;
			top: var(--top);
			left: var(--left);
			width: 100%;
			max-width: var(--mwidth);
			height: 100%;
			max-height: var(--maxheight);
			background-size: contain; 
			background-repeat: no-repeat;
		}

		bgimg.ignoreHeightMax > bgtag {
			padding: 1000px;
			margin: -1000px;
		}
		
		
		@media (max-width: 620px) {
			bgimg > bgtag {
				--left: 0;
			}
		}
		
	