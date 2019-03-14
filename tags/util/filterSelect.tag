filterSelect
	//-html
	input#filterText(type="text" placeholder="filter…" onkeydown="{ getListThrowFilter }") 
	drawItems
		drawItem(each="{ e, i in filterItems }")
			img(onclick="{ () => sendSelected(e) }" src="{ getSmallIconUrl(e) }" alt="{ e.name }")
		
	//-style
	style.	
		input#filterText {
			margin: 0 4px;
			padding: 1.5ex 1ex;
			width: 80%;
		}
		
		drawitems {
			border: 1px solid #888;
			border-radius: 4px;
			margin: .5ex;
			padding: 1ex;
			display: block;
			min-height: 300px;
			white-space: normal;
		}
		
		drawitem {
			display: inline-block;
			margin: 3px;
			width: 45px;
			height: 45px;
		}
		drawitem > img {
			width: 100%;
			height: 100%;
			cursor: pointer;
		}
	
		
	//-script
	script.
		var numeral = require("numeral");
		var $ = require("jquery");
		
		// フィルターを通す
		getListThrowFilter(){
			var lists = opts.lists || [];
			var filterText = $("#filterText").val();
			if(!filterText || filterText.length < 2){
				return this.filterItems = [];
			} else {
				return this.filterItems = lists.filter(e => {
					var alias = e.alias || [];
					return [e.name, ...alias].some(e => {
						return e.includes(filterText);
					})
				})
			}	
		}
		
		getSmallIconUrl(e) {
			var prex = `${e.prefix || ""}card_${numeral(e.imageno).format("00000")}`;
			return `https://i-quiz-colopl-jp.akamaized.net/img/card/small/${prex}_0.png`;
		}
		
		sendSelected(e) {
			opts.observer.trigger("filterSelectComplete", e);
		}
		