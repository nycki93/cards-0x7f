DIGITS := 0 1 2 3 4 5 6 7 8 9
ALPHAS := a b c d e f
SUITS := o x t s
RANKS := $(DIGITS) $(ALPHAS)
CARDS := \
	$(foreach r,$(RANKS),\
	$(foreach s,$(SUITS),\
		card-$(s)$(r).png))

DPI := 600
WIDTH := $(shell echo '$(DPI) * 2.5' | bc)
HEIGHT := $(shell echo '$(DPI) * 3.5' | bc)
GRID := $(shell echo '$(DPI) * 0.25' | bc)
GRID2 := $(shell echo '$(DPI) * 0.50' | bc)
GRID3 := $(shell echo '$(DPI) * 0.75' | bc)

DATA := \
	00 o 0 0 NUL \
	01 o 0 1 SOH \
	02 o 0 2 STX \
	03 o 0 3 ETX

all: $(CARDS)

rank-%.png:
	convert \
		-size $(GRID)x$(GRID) canvas:white \
		-fill black \
		-font 'Noto-Serif-Bold' -pointsize $(GRID) \
		-gravity center \
		-draw "text 0,0 '$(shell echo $* | tr [a-z] [A-Z])'" \
		$@

index-%.png:
	convert \
		-size $(GRID2)x$(GRID) canvas:white \
		-fill black \
		-font 'Noto-Serif-Bold' -pointsize $(GRID) \
		-gravity center \
		-draw "text 0,0 '$(shell echo $* | tr oxts 0246)'" \
		$@

text-%.png:
	convert \
		-size $(GRID2)x$(GRID) canvas:white \
		-fill black \
		-font 'Noto-Serif-Bold' -pointsize $(GRID) \
		-gravity center \
		-draw "text 0,0 '$*'" \
		$@

TEXT = text-$(word $(shell echo '5 * $r + 5' | bc),$(DATA)).png
define card
card-$s$r.png: blank.png base-$1-$s.png mask-$r.png suit-$s.png rank-$r.png index-$s$r.png $(TEXT)
	@echo "making card-$s$r.png."
	convert \
		blank.png \
		-draw "\
			gravity center \
			image over 0,0 0,0 base-$1-$s.png \
			image over 0,0 0,0 mask-$r.png \
			gravity northwest \
			image over $(GRID),$(GRID) 0,0 suit-$s.png \
			image over $(GRID),$(GRID2) 0,0 rank-$r.png \
			gravity northeast \
			image over $(GRID),$(GRID) 0,0 index-$s$r.png \
			image over $(GRID),$(GRID2) 0,0 $(TEXT) \
			rotate 180 \
			gravity southeast \
			image over 0,0 0,0 suit-$s.png \
			image over 0,-$(GRID) 0,0 rank-$r.png \
			gravity southwest \
			image over -$(GRID3),0 0,0 index-$s$r.png \
			image over -$(GRID3),-$(GRID) 0,0 $(TEXT) \
		"\
		-resize 50% \
		$$@
endef

$(foreach s,$(SUITS),\
	$(foreach r,$(DIGITS),$(eval $(call card,digit)))\
	$(foreach r,$(ALPHAS),$(eval $(call card,alpha)))\
)

clean:
	rm -f card-*.png index-*.png text-*.png