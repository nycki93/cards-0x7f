RANKS := 0 1 a b
SUITS := o
CARDS := \
	$(foreach r,$(RANKS),\
	$(foreach s,$(SUITS),\
		card-$(s)$(r).png))

DPI := 600
WIDTH := $(shell echo '$(DPI) * 2.5' | bc)
HEIGHT := $(shell echo '$(DPI) * 3.5' | bc)
GRID := $(shell echo '$(DPI) * 0.25' | bc)
GRID2 := $(shell echo '$(DPI) * 0.50' | bc)

all: $(CARDS)

card-%0.png: small-%.png
	convert \
		-size $(WIDTH)x$(HEIGHT) canvas:white \
		-draw "\
			gravity northwest \
			image over $(GRID),$(GRID) 0,0 small-$*.png \
			gravity southeast \
			rotate 180 \
			image over 0,0 0,0 small-$*.png \
		"\
		$@

card-%1.png: card-%0.png pips-1.png
	convert card-$*0.png \
		-draw "\
			gravity northwest \
			image over $(GRID),$(GRID2) 0,0 pips-1.png \
			gravity southeast \
			rotate 180 \
			image over 0,-$(GRID) 0,0 pips-1.png \
		"\
		$@

card-%a.png: card-%0.png face-%.png face-a.png
	convert card-$*0.png \
		-draw "\
			gravity center \
			image over 0,0 0,0 face-$*.png \
			image over 0,0 0,0 face-a.png \
		"\
		$@

card-%b.png: card-%0.png face-%.png face-b.png
	convert card-$*0.png \
		-draw "\
			gravity center \
			image over 0,0 0,0 face-$*.png \
			image over 0,0 0,0 face-b.png \
		"\
		$@

clean:
	rm -f card*.png