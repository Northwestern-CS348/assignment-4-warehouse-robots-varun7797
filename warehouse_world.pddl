(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
    (:action robotMove
        :parameters (?r - robot ?l1 - location ?l2 - location)
        :precondition (and (no-robot ?l2) (at ?r ?l1) (free ?r) (connected ?l1 ?l2))
        :effect (and (not (at ?r ?l1)) (no-robot ?l1) (at ?r ?l2) (not (no-robot ?l2)) )
   )
   
   (:action robotMoveWithPallette
        :parameters (?r - robot ?l1 - location ?l2 - location ?p - pallette)
	    :precondition (and (at ?r ?l1) (connected ?l1 ?l2) (at ?p ?l1) (no-robot ?l2)  (no-pallette ?l2) (free ?r))
	    :effect (and (at ?r ?l2) (no-robot ?l1) (at ?p ?l2) (not (at ?r ?l1)) (not (at ?p ?l1)) (no-pallette ?l1) (has ?r ?p) (not (no-robot ?l2)) (not (no-pallette ?l2)))   
    )

    (:action moveItemFromPallette
        :parameters (?l - location ?s - shipment ?si - saleitem  ?p - pallette ?o - order)
	    :precondition (and (at ?p ?l) (packing-location ?l) (packing-at ?s ?l) (ships ?s ?o) (contains ?p ?si) (orders ?o ?si) (started ?s))
	    :effect (and (not (contains ?p ?si)) (includes ?s ?si) (not (orders ?o ?si)))
   	)

    (:action completeShipment
	    :parameters (?s - shipment ?o - order ?l - location)
	    :precondition (and (ships ?s ?o) (started ?s) (not (available ?l)) (packing-location ?l) (not (complete ?s)))
	    :effect (and (available ?l) (complete ?s) (not (started ?s)) (not (packing-at ?s ?l)))
   	)

)
