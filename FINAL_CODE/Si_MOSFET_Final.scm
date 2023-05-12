;; Setting Parameters:


;; Defined Parameters:


;; Contact Sets:

;; Work Planes:
(sde:workplanes-init-scm-binding)

;; Defined ACIS Refinements:
(sde:refinement-init-scm-binding)

;; Restore GUI session parameters:
(sde:set-window-position 179 82)
(sde:set-swindow-size 840 800)
(sde:set-window-style "Windows")
(sde:set-background-color 0 127 178 204 204 204)
(sde:scmwin-set-prefs "DejaVu Sans Mono" "Normal" 10 100 )

;; NDK: define structure here!
(sde:clear)

(sdegeo:set-default-boolean "ABA")
	

; ***********************************************************************************************
; * DIMENSIONS OF THE MOSFET
; *		* NOTE: All the dimensions described here with its diverse lengths are all in µm
; *		* The <create-rectangle> command specifies a 2D rectangle using two opposing corners
; *		  with a region material and a name assigned. The first coordinate is on y (horizontal),
; * 	  the second coordinate is on x (vertical)
; ***********************************************************************************************
#|
Changes made so far:
	* reduced channel length by 60% (14nm)
	* reduced gate length by 61.5% (13.475nm)
	* changed gate oxide material to HfO2
	* change spacer materials to vacuum
	* increased concentration of the channel to 2.5e+19
	* decreased voltage supplied to 0.76 V
	* t_ox reduced to 4nm
	* source and drain extension concentrations decreased to 1.5e+19
|#
(define kappa 0.8)                              					; scaling factor t_ox
(define alpha 0.4)													; scaling factor channel length L
(define beta 1)														; scaling factor drain and source spacers
(define gamma 1)													; scaling factor channel depth
(define omega 0.385)												; scaling factor gate length L_ox
(define psi 1)														; scaling factor drain and source extension
(define channel_start (/ (- 0.035 (* 0.035 alpha)) 2))   			; start of channel
(define channel_end (- 0.035 (/ (- 0.035 (* 0.035 alpha)) 2)))    	; end of channel
(define gate_start (/ (- 0.035 (* 0.035 omega)) 2))   				; start of channel
(define gate_end (- 0.035 (/ (- 0.035 (* 0.035 omega)) 2)))    		; end of channel
(define t_ox_height (* -1 (* 0.005 kappa)))							; thickness of oxide
(define start_s_sp (+ gate_start (* -0.035 beta)))					; start of the spacer spacer
(define end_d_sp (+ gate_end (* 0.035 beta)))						; end of the drain spacer
(define start_s_ext (+ channel_start (* -0.035 psi)))				; start of the source extension
(define end_d_ext (+ channel_end (* 0.035 psi)))					; end of the drain extension
(define height_terminal (* 0.035 gamma))							; height of channel

;; silicon channel:
(sdegeo:create-rectangle (position channel_start 0 0.0 )  (position channel_end 0.035 0.0 ) "Silicon" "channel" )
;; gate oxide:
(sdegeo:create-rectangle (position gate_start 0 0 )  (position gate_end t_ox_height 0 ) "HfO2" "gate_oxide" )
;; Gate metal electrode:	
(sdegeo:create-rectangle (position gate_start t_ox_height 0 )  (position gate_end -0.05 0 ) "Aluminum" "gate_electrode" )

;; Body metal electrode: 
(sdegeo:create-rectangle (position -0.07 0.6 0 )  (position 0.105 0.5 0 ) "Aluminum" "body_electrode" )
;; body silicon:
(sdegeo:create-rectangle (position -.07 .5 0 )  (position .105 height_terminal 0 ) "Silicon" "body" )

;; Source metal electrode:
(sdegeo:create-rectangle (position -0.07 0 0 )  (position start_s_ext -0.05 0 ) "Aluminum" "source_electrode" )
;; silicon under source metal:
(sdegeo:create-rectangle (position -0.07 height_terminal 0 )  (position start_s_ext 0 0 ) "Silicon" "source_n" )

;; spacer oxide between metal gate and metal source:
(sdegeo:create-rectangle (position gate_start 0 0 )  (position start_s_sp -0.05 0 ) "Vacuum" "spacerL" )
;; silicon between silicon under source metal and silicon channel, called source extension:
(sdegeo:create-rectangle (position start_s_ext height_terminal 0 )  (position channel_start 0 0 ) "Silicon" "source_n_ext" )

;; Drain metal electrode:
(sdegeo:create-rectangle (position end_d_ext 0 0 )  (position 0.105 -0.05 0.0 ) "Aluminum" "drain_electrode" )
;; silicon under drain metal:
(sdegeo:create-rectangle (position end_d_ext height_terminal 0 )  (position 0.105 0 0 ) "Silicon" "drain_n" )

;; spacer oxide between metal gate and metal drain:
(sdegeo:create-rectangle (position gate_end 0 0 )  (position end_d_sp -0.05 0 ) "Vacuum" "spacerR" )
;; silicon between silicon under drain metal and silicon channel, called drain extension:
(sdegeo:create-rectangle (position channel_end height_terminal 0 )  (position end_d_ext 0 0 ) "Silicon" "drain_n_ext" )
	

; ***********************************************************************************************
; * ASSIGNMENT OF THE DOPING OF SECTIONS OF THE MOSFET
; *		* Note how we can choose whether we want the channel to be doped in a constant
; *	      manner, whether we want it doped with Boron, Phosphorus or other elements 
; * 	  and the exact concentration.
; ***********************************************************************************************
;; channel doping:
(sdedr:define-constant-profile "constant_channel_doping" "BoronActiveConcentration" 2.5e+19) 
(sdedr:define-constant-profile-region "constant_channel_doping_placement" "constant_channel_doping" "channel")
;; drain extension doping:
(sdedr:define-constant-profile "constant_drain_ext_doping" "PhosphorusActiveConcentration" 1.5e+20)
(sdedr:define-constant-profile-region "constant_drain_ext_doping_placement" "constant_drain_ext_doping" "drain_n_ext")
;; drain doping:
(sdedr:define-constant-profile "constant_drain_doping" "PhosphorusActiveConcentration" 5e+19)
(sdedr:define-constant-profile-region "constant_drain_doping_placement" "constant_drain_doping" "drain_n")
;; source extension doping:
(sdedr:define-constant-profile "constant_source_ext_doping" "PhosphorusActiveConcentration" 1.5e+20)
(sdedr:define-constant-profile-region "constant_source_ext_doping_placement" "constant_source_ext_doping" "source_n_ext")
;; source doping:
(sdedr:define-constant-profile "constant_source_doping" "PhosphorusActiveConcentration" 5e+19)
(sdedr:define-constant-profile-region "constant_source_doping_placement" "constant_source_doping" "source_n")
;; body doping:
(sdedr:define-constant-profile "constant_body_doping" "BoronActiveConcentration" 4e+19) 
(sdedr:define-constant-profile-region "constant_body_doping_placement" "constant_body_doping" "body")

;; define contacts
(sdegeo:define-contact-set "Gate_contact" 4  (color:rgb 1 0 0 ) "##" )
(sdegeo:define-contact-set "Body_contact" 4  (color:rgb 1 1 0 ) "##" )
(sdegeo:define-contact-set "Source_contact" 4  (color:rgb 1 0 1 ) "##" )
(sdegeo:define-contact-set "Drain_contact" 4  (color:rgb 1 1 1 ) "##" )

;; assign location of contacts
(sdegeo:set-current-contact-set "Gate_contact")
(sdegeo:set-contact-boundary-edges (list (car (find-body-id (position 0.0175 -0.04 0)))) "Gate_contact")
(sdegeo:set-current-contact-set "Source_contact")
(sdegeo:set-contact-boundary-edges (list (car (find-body-id (position -.06 -0.04 0)))) "Source_contact")
(sdegeo:set-current-contact-set "Drain_contact")
(sdegeo:set-contact-boundary-edges (list (car (find-body-id (position 0.1 -0.04 0)))) "Drain_contact")
(sdegeo:set-current-contact-set "Body_contact")
(sdegeo:set-contact-boundary-edges (list (car (find-body-id (position 0.02 0.55 0)))) "Body_contact")


;; make mesh
;; define and set top mesh, everything above the surface of the silicon:
(sdedr:define-refeval-window "RefWin_1" "Rectangle"  (position -0.07 0 0) (position 0.105 -0.05 0))
(sdedr:define-refinement-size "RefinementDefinition_1" 0.002 0.001 0.005 0.002 )
(sdedr:define-refinement-placement "RefinementPlacement_1" "RefinementDefinition_1" "RefWin_1" )
;; define and set the bottom mesh, everything below the surface of the silicon:
(sdedr:define-refeval-window "RefWin_2" "Rectangle"  (position -0.07 .6 0) (position 0.105 0 0))
(sdedr:define-multibox-size "MultiboxDefinition_1" 0.05 0.03 .0003 .0002 1 1.35 )
(sdedr:define-multibox-placement "MultiboxPlacement_1" "MultiboxDefinition_1" "RefWin_2" )
;; define and set the mesh over the channel:
(sdedr:define-refinement-size "RefinementDefinition_2" 0.002 .005 .0000001 0.0000002 )
(sdedr:define-refinement-region "RefinementPlacement_3" "RefinementDefinition_2" "channel" )


;; save file here
;; MANUALLY SAVE THE FILE WITH A FILENAME HERE BEFORE DOING MESHING!!!

(sde:save-model "Si_MOSFET")

;; manually build mesh
;; mesh->build mesh

;; save file

(sde:build-mesh "snmesh" "" "Mesh_Si_MOSFET")
