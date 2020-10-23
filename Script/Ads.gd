extends HBoxContainer

onready var admob = $AdMob
onready var debug_out = $DebugOut

func _ready():
	loadAds()
# warning-ignore:return_value_discarded
	get_tree().connect("screen_resized", self, "_on_resize")
	
	write_debug("Debug started.")
	
	if not Engine.has_singleton("GodotAdMob"):
		write_debug("Could not find GodotAdMob singleton.")
		
func write_debug(msg: String):
	debug_out.text = debug_out.text + msg + "\n"

func loadAds() -> void:
	admob.load_banner()
	admob.load_interstitial()
	admob.load_rewarded_video()
	
func _on_resize():
	write_debug("Banner resized\n") 
	admob.banner_resize()

func _on_Banner_toggled(button_pressed):
	if button_pressed: admob.show_banner()
	else: admob.hide_banner()

func _on_Interstitial_pressed():
	write_debug("Interstitial loaded before shown = " + str(admob.is_interstitial_loaded()))
	admob.show_interstitial()
	write_debug("Interstitial loaded after shown = " + str(admob.is_interstitial_loaded()))

func _on_Banner_resized():
	admob.banner_resize()

func _on_AdMob_banner_failed_to_load(error_code):
	write_debug("Banner failed to load: Error code " + str(error_code))

func _on_AdMob_banner_loaded():
	$"CanvasLayer/BtnBannerResize".disabled = false
	$"CanvasLayer/BtnBanner".disabled = false
	$"CanvasLayer/BtnBannerMove".disabled = false
	write_debug("Banner loaded")
	write_debug("Banner size = " + str(admob.get_banner_dimension()))

func _on_AdMob_interstitial_loaded():
	$"CanvasLayer/BtnInterstitial".disabled = false
	write_debug("Interstitial loaded")

func _on_AdMob_interstitial_closed():
	write_debug("Interstitial closed")
	$"CanvasLayer/BtnInterstitial".disabled = true

func _on_AdMob_interstitial_failed_to_load(error_code):
	write_debug("Interstitial failed to load: Error code " + str(error_code))

func _on_Reload_pressed():
	loadAds()
