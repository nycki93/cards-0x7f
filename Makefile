RANKS := 0 1 a
SUITS := o
CARDS := \
	$(foreach r,$(RANKS),\
	$(foreach s,$(SUITS),\
		card-$(s)$(r).png))

all: $(CARDS)

symbol-o.png:
	convert -size 25x25 canvas:transparent \
		+antialias \
		-draw "\
			translate 12.5,12.5 \
			fill black \
			circle 0,0 0,10 \
			fill white \
			circle 0,0 0,5 \
		"\
		$@

symbol-o1.png:
	convert \
		-size 50x50 canvas:transparent \
		+antialias \
		-draw "\
			translate 24.5,24.5 \
			fill black \
			circle 0,0 0,25 \
			fill white \
			circle 0,0 0,12.5 \
		"\
		$@

symbol-a.png:
	convert \
		-size 25x25 canvas:white \
		+antialias \
		-font Noto-Serif-Bold -fill black -pointsize 28 \
		-gravity center \
		-annotate +1+0 A \
		$@

symbol-a1.png:
	convert \
		-size 100x100 canvas:white \
		+antialias \
		-font Noto-Serif-Bold -fill black -pointsize 100 \
		-gravity center \
		-pointsize 100 \
		-annotate +0+0 A \
		$@

base-o0.png: symbol-o.png
	convert \
		-size 200x350 canvas:white \
		-draw "\
			gravity northwest \
			image over 0,0 0,0 symbol-o.png \
			gravity southeast \
			image over 0,0 0,0 symbol-o.png \
		"\
		$@

base-oa.png: card-o0.png symbol-a.png
	convert card-o0.png \
		-draw "\
			gravity northwest \
			image over 0,25 0,0 symbol-a.png \
			gravity southeast \
			rotate 180 \
			image over 25,0 0,0 symbol-a.png \
		"\
		$@

card-o0.png: base-o0.png
	cp base-o0.png $@

card-o1.png: base-o0.png symbol-o1.png
	convert \
		base-o0.png \
		-draw 'image over 75,150 0,0 symbol-o1.png' \
		$@

card-oa.png: base-oa.png symbol-a1.png
	convert base-oa.png \
		-gravity center \
		-draw 'image over 0,0 0,0 symbol-a1.png' \
		$@

clean-temp:
	rm symbol*.png base*.png

clean:
	rm symbol*.png base*.png card*.png