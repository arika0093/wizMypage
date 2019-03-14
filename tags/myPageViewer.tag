myPageViewer
	//-html
	myPageBackground#mypagebackground
		backgroundImage
			bgimg(imagesrc="{backgroundImage}" width="auto 100vh" y="center")
		myPageCharactor
			bgimg.ignoreHeightMax(imagesrc="{this.imageUrl}"
				width="{imageSize}" position="{imagePosition}" y="center" 
				left="{imageLeft || 0}" top="{imageTop || 0}")
		headerImage(class="{hidden: !this.isVisibleUI}")
			bgimg(imagesrc="./static/items/header.png" maxwidth="620px"  y="top")
		footerImage(class="{hidden: !this.isVisibleUI}")
			bgimg(imagesrc="./static/items/footer.png" maxwidth="620px"  y="bottom")
		
	myPageOption(class="{ isSideShow: isHidden }")
		virtual(if="{!isHidden}")
			span(onclick="{ () => this.isHidden = true; }") ≪
			span(onclick="{ () => this.isShowCardUI = true; }") #カード
			span(onclick="{ () => this.isShowBgUI = true; }") #背景
			span(onclick="{ () => this.isVisibleUI = !this.isVisibleUI; }") UI表示切替
			span(onclick="{ () => generateRandomizeCard(); }") Random
			span(onclick="{ resetOnFirstPosition }") Reset
		virtual(if="{isHidden}")
			span(onclick="{ () => this.isHidden = false; }") ≫
	
	myPageCardSelector(if="{isShowCardUI}")
		span.close(onclick="{ () => this.isShowCardUI = false; }") ×
		filterSelect(lists="{ cards }" observer="{ observer }")
		
	myPageBgSelector(if="{isShowBgUI}")
		span.close(onclick="{ () => this.isShowBgUI = false; }") ×
		filterSelectBackground(lists="{ bgs }" observer="{ observer }")
			
	//-style
	style.
		mypageviewer {
			display: block;
			position: relative;
			width: 100%;
			height: 100%;
			max-width: 80vh;
			margin: 0 auto;
			overflow: hidden;
			white-space: nowrap;
		}
		
		mypagecharactor > bgimg {
			width: 80%;
			height: 100%;
		}

		mypageoption {
			--width: 350px;
			position: absolute;
			width: var(--width);
			max-width: 100%;
			left: calc(50% - var(--width) / 2 );
			top: 0;
			padding: 4px;
			margin: 2px;
			background: #000;
			color: #FFF;
			transition: .5s ease;
			overflow: hidden;
		}

		mypageoption > span {
			padding: 1ex .5ex; 
			font-size: 14px;
		}
		mypageoption.isSideShow > span{
			padding: 3px;
		}

		mypageoption > span:hover {
			cursor: pointer;
			text-decoration: underline;
		}

		mypageoption.isSideShow {
			left: 0;
			width: 20px;
		}

		mypagecardselector, mypagebgselector{
			position: absolute;
			top: 1ex;
			left: 1ex;
			width: calc(100% - 2ex);
			height: calc(100vh - 2ex);
			background: rgba(255,255,255,0.9);
		}
		.close {
			display: block;
			text-align: right;
			padding: 0 1ex;
			font-size: 1.5rem;
			cursor: pointer;
		}
		.hidden {
			display: none;
		}
		
	//-script
	script.
		// utility
		var $ = require("jquery");
		var numeral = require("numeral");
		// setting file
		var cards = this.cards = require("./datas/cards.json");
		var bgs   = this.bgs   = require("./datas/backgrounds.js");
		// tag file
		import "./util/bgimg.tag";
		import "./util/filterSelect.tag";
		import "./util/filterSelectBackground.tag";
		
		const BackGroundPath = `./static/bg`;
		const ImageHostUrl = `https://i-quiz-colopl-jp.akamaized.net/img/card/high`;
		//const DefaultCard = "card_08133"; //"Vi3rCS_card_13774"; 
		const ZoomMin = 0.1;
		const ZoomMax = 2.5;
		const imageZoomDefault = 0.7;
		const imageSizeDefault = `560px 717px`;
		
		this.backgroundImage = `${BackGroundPath}/quesalias.png`;
		//this.imageUrl = `${ImageHostUrl}/${DefaultCard}_2_high.png`;
		this.imageIndex = 0;
		this.imageBaseSize = 1024;
		this.imageZoomRate = imageZoomDefault;
		this.imageSize = imageSizeDefault;
		this.imageTop = 0, this.imageLeft = 0;
		
		this.isShowCardUI = false;
		this.isHidden = false;
		this.isVisibleUI = true;
		
		this.observer = riot.observable();

		this.on("mount", () => {
			
			// on mouse event
			var mousewheelevent = 'onwheel' in document ? 'wheel' : 'onmousewheel' in document ? 'mousewheel' : 'DOMMouseScroll';
			$("#mypagebackground").on(mousewheelevent, (e) => {
				e.preventDefault();
				var delta = e.originalEvent.deltaY ? -(e.originalEvent.deltaY) : e.originalEvent.wheelDelta ? e.originalEvent.wheelDelta : -(e.originalEvent.detail);
				// 画像倍率変更
				var zr = this.imageZoomRate + 0.02 * (delta < 0 ? -1 : 1);
				this.imageZoomRate = zr.clamp(ZoomMin, ZoomMax);
				var h = this.imageBaseSize * this.imageZoomRate;
				var w = h * 0.78;
				this.imageSize = `${numeral(w).format("0")}px ${numeral(h).format("0")}px`;
				this.update();
			})
			
			// pinch/move event capture
			$("#mypagebackground")
				.on("mousedown touchstart", (e) => {
					if(e.touches && e.touches.length === 2){
						// pinch action
						this.pinchMode = true;
						this.moveMode = false;
						this.beforeDistance = Math.hypot(
							e.touches[0].pageX - e.touches[1].pageX,
							e.touches[0].pageY - e.touches[1].pageY);
						//-$("#debug").text(this.firstDistance);
					} else {
						// move action
						this.pinchMode = false;
						this.moveMode = true;
						var x = e.changedTouches ? e.changedTouches[0].pageX : e.clientX;
						var y = e.changedTouches ? e.changedTouches[0].pageY : e.clientY;
						this.moveFirstPosition = {
							x, y,
							t: this.imageTop,
							l: this.imageLeft
						};
					}
				})
				.on("mouseup touchend", (e) => {
					this.pinchMode = this.moveMode = false;
				});
			
			var onMoveAction = (e) => {
				e.preventDefault();
				if (this.pinchMode) {
					var dist = Math.hypot(
						e.touches[0].pageX - e.touches[1].pageX,
						e.touches[0].pageY - e.touches[1].pageY);
					//-$("#debug").text(`${dist}, ${this.beforeDistance}`);
					var isZoom = (dist > this.beforeDistance);
					var zr = this.imageZoomRate + 0.025 * (isZoom ? 1 : -1);
					this.imageZoomRate = zr.clamp(ZoomMin, ZoomMax);
					
					var h = this.imageBaseSize * this.imageZoomRate;
					var w = h * 0.8;
					this.imageSize = `${numeral(w).format("0")}px ${numeral(h).format("0")}px`;
					this.beforeDistance = dist;
					this.update();
				} else if (this.moveMode) {
					// 座標の取得
					var moveX = e.changedTouches ? e.changedTouches[0].pageX : e.clientX;
					var moveY = e.changedTouches ? e.changedTouches[0].pageY : e.clientY;
					// diff取得
					var diffX = moveX - this.moveFirstPosition.x;
					var diffY = moveY - this.moveFirstPosition.y;
					// 移動
					this.imageLeft = Math.floor(diffX) + this.moveFirstPosition.l;
					this.imageTop = Math.floor(diffY) + this.moveFirstPosition.t;
					this.update();
				}
				
			};
			var t = $("#mypagebackground")[0];
			t.addEventListener("mousemove", onMoveAction);
			t.addEventListener("touchmove", onMoveAction, { passive: false });
		
		});
		
		
		resetOnFirstPosition() {
			this.imageZoomRate = imageZoomDefault;
			this.imageSize = imageSizeDefault;
			this.imageTop = 0, this.imageLeft = 0;
			this.imageIndex = 0;
			//this.backgroundImage = `${BackGroundPath}/quesalias.png`;
			this.isHidden = false;
			this.isVisibleUI = true;
			this.update();
		}
		
		backgroundImageChange() {
			var bgkeys = Object.keys(bgs);
			var bgsl = bgkeys.length;
			this.imageIndex = (this.imageIndex + 1) % bgsl;
			var bgk = bgkeys[this.imageIndex];
			this.backgroundImage = `${BackGroundPath}/${bgs[bgk]}`;
		}
		
		this.generateRandomizeCard = () => {
			var e = this.cards.sample();
			var prex = `${e.prefix || ""}card_${numeral(e.imageno).format("00000")}`;
			this.imageUrl = `${ImageHostUrl}/${prex}_2_high.png`;
		}
		
		this.observer.on("filterSelectComplete", (e) => {
			var prex = `${e.prefix || ""}card_${numeral(e.imageno).format("00000")}`;
			this.imageUrl = `${ImageHostUrl}/${prex}_2_high.png`;
			this.isShowCardUI = false;
			this.update();
		})
		
		this.observer.on("filterSelectBgComplete", (v) => {
			this.backgroundImage = `${BackGroundPath}/${v}`;
			this.isShowBgUI = false;
			this.update();
		})
		
		this.generateRandomizeCard();
		