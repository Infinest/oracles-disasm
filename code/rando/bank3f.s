; gfx-related stuff here. Namespace "bank3f".

;;
; Overrides the sprite data loaded for certain interactions. This is mostly used for "non-item"
; interactions that depict items, like the ones in shops.
;
; @param	hl	Pointer to interactionData (may be modified)
checkLoadCustomSprite:
	push af
	push bc
	push hl
	ld e,Interaction.id
	ld a,(de)
	ld b,a
	inc e
	ld a,(de) ; subid
	ld c,a
	ld e,$02
	ld hl,customSpriteLookupTable
	call searchDoubleKey
	jr nc,@done

	ldi a,(hl)
	ld c,a
	ld b,(hl)
	pop hl
	callab rando.lookupItemSlot
	call lookupItemSprite
	pop bc
	pop af
	ret

@done:
	pop hl
	pop bc
	pop af
	ret


;;
; @param	bc	Treasure object ID to get graphics for
; @param[out]	hl	Address of sprite data (pointing somewhere in "data/{game}/interactionData.s")
lookupItemSprite:
	callab treasureData.getTreasureDataSprite
	ld a,e
	ld hl,interaction60SubidData
	add a
	rst_addAToHl
	ld a,e
	rst_addAToHl
	ret


; Format:
; - Interaction ID
; - SubID
; - Item slot to use for gfx (little-endian word)
customSpriteLookupTable:

.ifdef ROM_SEASONS
	dbbw INTERACID_HEROS_CAVE_SWORD_CHEST, $00, rando.seasonsSlot_d0SwordChest
	dbbw INTERACID_SHOP_ITEM,              $00, rando.seasonsSlot_membersShop1
	dbbw INTERACID_SHOP_ITEM,              $02, rando.seasonsSlot_membersShop2
	dbbw INTERACID_SHOP_ITEM,              $05, rando.seasonsSlot_membersShop3
	dbbw INTERACID_SHOP_ITEM,              $0d, rando.seasonsSlot_shop150Rupees
	dbbw INTERACID_GET_ROD_OF_SEASONS,     $02, rando.seasonsSlot_templeOfSeasons
	dbbw INTERACID_SUBROSIAN_SHOP,         $00, rando.seasonsSlot_subrosiaMarket1stItem
	dbbw INTERACID_SUBROSIAN_SHOP,         $04, rando.seasonsSlot_subrosiaMarket2ndItem
	dbbw INTERACID_SUBROSIAN_SHOP,         $0d, rando.seasonsSlot_subrosiaMarket5thItem
	.db $ff

.else; ROM_AGES
	; RANDO-TODO
	.db $ff
.endif


; Format: Interaction ID; subID; jump address.
; These functions *must* pop af as the last instruction before returning.
customSpriteJumpTable:
;	dbbw $59, $00, setPedestalSprite
;	dbbw $6e, $00, setStolenFeatherSprite
;	dbbw $81, $00, setMarket1Sprite
;	dbbw $81, $04, setMarket2Sprite
;	dbbw $81, $0d, setMarket5Sprite
;	dbbw $e6, $02, setTempleOfSeasonsSprite
	.db $ff


