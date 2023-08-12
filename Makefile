RANKS := 0 1 a
SUITS := o
CARDS := \
	$(foreach r,$(RANKS),\
	$(foreach s,$(SUITS),\
		card-$(s)$(r).png))

PPI := 300
WIDTH := 2.5
HEIGHT := 3.5
SPACING := 0.25
W := $(shell echo '$(PPI) * $(WIDTH)' | bc)
H := $(shell echo '$(PPI) * $(HEIGHT)' | bc)
S := $(shell echo '$(PPI) * $(SPACING)' | bc)
D := $(shell echo '$(S) / 5' | bc)
DS := $(shell echo '$(D) * 1.25' | bc)
WW := $(shell echo '$(W) / 2' | bc)
HH := $(shell echo '$(H) / 2' | bc)
SS := $(shell echo '$(S) / 2' | bc)
DD := $(shell echo '$(D) / 2' | bc)
DW := $(shell echo '$(DD) * 0.75' | bc)

all: $(CARDS) number-1.png number-2.png number-9.png

dot.png:
	convert -size $(D)x$(D) canvas:white \
	-fill black \
	-draw "translate $(DD),$(DD) circle 0,0 0,$(DW)" \
	$@

number-1.png: dot.png
	convert -size $(S)x$(S) canvas:white \
		-fill black \
		-gravity center \
		-draw 'image over 0,0 0,0 dot.png' \
		$@

number-2.png: dot.png
	convert -size $(S)x$(S) canvas:white \
		-draw "\
			gravity center \
			image over -$(DS),$(DS) 0,0 dot.png \
			image over $(DS),-$(DS) 0,0 dot.png \
		"\
		$@

number-9.png: dot.png
	convert -size 75x75 canvas:white \
		-draw "\
			gravity center \
			image over 0,0 0,0 dot.png \
			image over 0,$(DS) 0,0 dot.png \
			image over 0,-$(DS) 0,0 dot.png \
			image over $(DS),0 0,0 dot.png \
			image over $(DS),$(DS) 0,0 dot.png \
			image over $(DS),-$(DS) 0,0 dot.png \
			image over -$(DS),0 0,0 dot.png \
			image over -$(DS),$(DS) 0,0 dot.png \
			image over -$(DS),-$(DS) 0,0 dot.png \
		"\
		$@

small-o.png:
	convert -size 75x75 canvas:transparent \
		+antialias \
		-fill black \
		-draw "circle 38,38 38,5.5" \
		-fill white \
		-draw "circle 38,38 38,25.5" \
		$@

large-o.png:
	convert \
		-size 150x150 canvas:transparent \
		-fill black \
		-draw 'circle 74.5,74.5 74.5,10.5' \
		$@

small-a.png:
	convert \
		-size 75x75 canvas:white \
		+antialias \
		-font Noto-Serif-Bold -fill black -pointsize 84 \
		-gravity center \
		-annotate +1+0 A \
		$@

large-a.png:
	convert \
		-size 300x300 canvas:white \
		-font Noto-Serif-Bold -fill black -pointsize 300 \
		-gravity center \
		-annotate +1+0 A \
		$@

card-%0.png: small-%.png
	convert \
		-size 600x1050 canvas:white \
		-draw "\
			gravity northwest \
			image over 0,0 0,0 small-$*.png \
			gravity southeast \
			rotate 180 \
			image over 75,75 0,0 small-$*.png \
		"\
		$@

card-%1.png: card-%0.png number-9.png large-%.png
	convert card-$*0.png \
		-draw "\
			image over 75,450 0,0 large-$*.png \
			gravity northwest \
			image over 0,75 0,0 number-9.png \
			gravity southeast rotate 180 \
			image over 75,0 0,0 number-9.png \
		"\
		$@

card-%a.png: card-%0.png small-a.png large-a.png
	convert card-$*0.png \
		-draw "\
			gravity northwest \
			image over 0,75 0,0 small-a.png \
			gravity southeast rotate 180 \
			image over 75,0 0,0 small-a.png \
			gravity center rotate 180 \
			image over 0,0 0,0 large-a.png \
		"\
		$@

clean-temp:
	rm -f small*.png large*.png

clean:
	rm -f *.png