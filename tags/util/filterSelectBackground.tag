filterSelectBackground
	BgItems
		BgItem(each="{ value, key in opts.lists }" onclick="{ () => sendBgSelected(value) }")
			span {key}
	
		
	style.
		bgitems {
			border: 1px solid #888;
			border-radius: 4px;
			margin: .5ex;
			padding: 1ex;
			display: block;
			min-height: 200px;
			max-height: 500px;
			white-space: normal;
			overflow: scroll;
		}
		
		bgitem {
			display: block;
			padding: 1ex;
			margin: 2px;
			border: 1px solid #CCC;
		}
		bgitem:hover{
			cursor: pointer;
			background: #F0F0F0;
			border: 1px solid #888;
		}
		
	script.
		
		sendBgSelected(v) {
			opts.observer.trigger("filterSelectBgComplete", v);
		}
		