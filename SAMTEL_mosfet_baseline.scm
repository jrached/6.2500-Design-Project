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
(define kappa 1.3)                              		; scaling factor
(define channel_start 0)   								; start of channel
(define channel_end 0.035)    							; end of channel
(define t_ox_height (* -1 (* 0.005 kappa)))				; thickness of oxide
(define start_s_ext (* -0.035 1.05))					; start of the source extension
(define end_d_ext (+ 0.035 (* 0.035 1.05)))				; end of the drain extension

;; silicon channel:
(sdegeo:create-rectangle (position channel_start 0 0.0 )  (position channel_end 0.035 0.0 ) "Silicon" "channel" )
;; gate oxide:
(sdegeo:create-rectangle (position channel_start 0 0 )  (position channel_end t_ox_height 0 ) "SiO2" "gate_oxide" )
;; Gate metal electrode:
(sdegeo:create-rectangle (position channel_start t_ox_height 0 )  (position channel_end -0.05 0 ) "Aluminum" "gate_electrode" )

;; Source metal electrode:
(sdegeo:create-rectangle (position -0.07 0 0 )  (position start_s_ext -0.05 0 ) "Aluminum" "source_electrode" )
;; silicon under source metal:
(sdegeo:create-rectangle (position -0.07 0.035 0 )  (position start_s_ext 0 0 ) "Silicon" "source_n" )

;; spacer oxide between metal gate and metal source:
(sdegeo:create-rectangle (position channel_start 0 0 )  (position start_s_ext -0.05 0 ) "SiO2" "spacerL" )
;; silicon between silicon under source metal and silicon channel, called source extension:
(sdegeo:create-rectangle (position start_s_ext .035 0 )  (position channel_start 0 0 ) "Silicon" "source_n_ext" )
;; body region below source extension
;(sdegeo:create-rectangle (position -0.035 0.005 0 )  (position channel_start 0 0 ) "Silicon" "source_n_ext" )
;(sdegeo:create-rectangle (position -0.035 0.035 0 )  (position channel_start 0.005 0 ) "Silicon" "body_s_extension" )

;; Drain metal electrode:
(sdegeo:create-rectangle (position end_d_ext 0 0 )  (position 0.105 -0.05 0.0 ) "Aluminum" "drain_electrode" )
;; silicon under drain metal:
(sdegeo:create-rectangle (position end_d_ext .035 0 )  (position 0.105 0 0 ) "Silicon" "drain_n" )

;; spacer oxide between metal gate and metal drain:
(sdegeo:create-rectangle (position channel_end 0 0 )  (position end_d_ext -0.05 0 ) "SiO2" "spacerR" )
;; silicon between silicon under drain metal and silicon channel, called drain extension:
(sdegeo:create-rectangle (position channel_end .035 0 )  (position end_d_ext 0 0 ) "Silicon" "drain_n_ext" )
;; body region below drain extension
;(sdegeo:create-rectangle (position channel_end 0.005 0 )  (position .07 0 0 ) "Silicon" "drain_n_ext" )
;(sdegeo:create-rectangle (position channel_end 0.035 0 )  (position .07 0.005 0 ) "Silicon" "body_d_extension" )

;; Body metal electrode: 
(sdegeo:create-rectangle (position -0.07 0.6 0 )  (position 0.105 0.5 0 ) "Aluminum" "body_electrode" )
;; body silicon:
(sdegeo:create-rectangle (position -.07 .5 0 )  (position .105 .035 0 ) "Silicon" "body" )
;(sdegeo:create-rectangle (position -.07 .07 0 )  (position .105 .035 0 ) "Silicon" "body1" )
;(sdegeo:create-rectangle (position -.07 .3 0 )  (position -0.02625 .07 0 ) "Silicon" "body_left_halo" )
;(sdegeo:create-rectangle (position -0.02625 .3 0 )  (position 0.06125 .07 0 ) "Silicon" "halo" )
;(sdegeo:create-rectangle (position 0.06125 .3 0 )  (position .105 .07 0 ) "Silicon" "body_right_halo" )
;(sdegeo:create-rectangle (position -.07 .5 0 )  (position .105 .3 0 ) "Silicon" "body2" )


; ***********************************************************************************************
; * ASSIGNMENT OF THE DOPING OF SECTIONS OF THE MOSFET
; *		* Note how we can choose whether we want the channel to be doped in a constant
; *	      manner, whether we want it doped with Boron, Phosphorus or other elements 
; * 	  and the exact concentration.
; ***********************************************************************************************
;; channel doping:
(sdedr:define-constant-profile "constant_channel_doping" "BoronActiveConcentration" 3e18)
(sdedr:define-constant-profile-region "constant_channel_doping_placement" "constant_channel_doping" "channel")
;; drain extension doping:
(sdedr:define-constant-profile "constant_drain_ext_doping" "PhosphorusActiveConcentration" 5e+18)
(sdedr:define-constant-profile-region "constant_drain_ext_doping_placement" "constant_drain_ext_doping" "drain_n_ext")
;; drain doping:
(sdedr:define-constant-profile "constant_drain_doping" "PhosphorusActiveConcentration" 5e+19)
(sdedr:define-constant-profile-region "constant_drain_doping_placement" "constant_drain_doping" "drain_n")
;; source extension doping:
(sdedr:define-constant-profile "constant_source_ext_doping" "PhosphorusActiveConcentration" 5e+19)
(sdedr:define-constant-profile-region "constant_source_ext_doping_placement" "constant_source_ext_doping" "source_n_ext")
;; source doping:
(sdedr:define-constant-profile "constant_source_doping" "PhosphorusActiveConcentration" 5e+19)
(sdedr:define-constant-profile-region "constant_source_doping_placement" "constant_source_doping" "source_n")
;; body doping:
(sdedr:define-constant-profile "constant_body_doping" "BoronActiveConcentration" 5e+19)
(sdedr:define-constant-profile-region "constant_body_doping_placement" "constant_body_doping" "body")
;(sdedr:define-constant-profile-region "constant_body1_doping_placement" "constant_body_doping" "body1")
;(sdedr:define-constant-profile-region "constant_body2_doping_placement" "constant_body_doping" "body2")
;(sdedr:define-constant-profile-region "constant_body_left_halo_doping_placement" "constant_body_doping" "body_left_halo")
;(sdedr:define-constant-profile-region "constant_body_right_halo_doping_placement" "constant_body_doping" "body_right_halo")
;(sdedr:define-constant-profile-region "constant_body_s_extension_doping_placement" "constant_body_doping" "body_s_extension")
;(sdedr:define-constant-profile-region "constant_body_d_extension_doping_placement" "constant_body_doping" "body_d_extension")
;; halo doping:
;(sdedr:define-constant-profile "constant_halo_doping" "BoronActiveConcentration" 5e+20)
;(sdedr:define-constant-profile-region "constant_halo_doping_placement" "constant_halo_doping" "halo")

;; define contacts
(sdegeo:define-contact-set "Gate_contact" 4  (color:rgb 1 0 0 ) "##" )
(sdegeo:define-contact-set "Body_contact" 4  (color:rgb 1 1 0 ) "##" )
(sdegeo:define-contact-set "Source_contact" 4  (color:rgb 1 0 1 ) "##" )
(sdegeo:define-contact-set "Drain_contact" 4  (color:rgb 1 1 1 ) "##" )

;; assign location of contacts
(sdegeo:set-current-contact-set "Gate_contact")
(sdegeo:set-contact-boundary-edges (list (car (find-body-id (position 0.02 -0.04 0)))) "Gate_contact")
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
(sdedr:define-multibox-size "MultiboxDefinition_1" 0.05 0.03 .03 .0002 1 1.35 )
(sdedr:define-multibox-placement "MultiboxPlacement_1" "MultiboxDefinition_1" "RefWin_2" )
;; define and set the mesh over the channel:
(sdedr:define-refinement-size "RefinementDefinition_1" 0.002 .005 .001 0.002 )
(sdedr:define-refinement-region "RefinementPlacement_3" "RefinementDefinition_1" "channel" )


;; save file here
;; MANUALLY SAVE THE FILE WITH A FILENAME HERE BEFORE DOING MESHING!!!

(sde:save-model "Si_MOSFET")

;; manually build mesh
;; mesh->build mesh

;; save file

(sde:build-mesh "snmesh" "" "Mesh_Si_MOSFET")
