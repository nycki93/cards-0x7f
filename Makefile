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

all: $(CARDS)

define card
card-$s$r.png: blank.png base-$1-$s.png mask-$r.png suit-$s.png rank-$r.png
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
			gravity southeast rotate 180 \
			image over 0,0 0,0 suit-$s.png \
			image over 0,-$(GRID) 0,0 rank-$r.png \
		"\
		-resize 50% \
		$$@
endef

$(foreach s,$(SUITS),\
	$(foreach r,$(DIGITS),$(eval $(call card,digit)))\
	$(foreach r,$(ALPHAS),$(eval $(call card,alpha)))\
)

clean:
	rm -f card*.png