#  RouterOS 
/ip firewall mangle
add action=mark-connection chain=prerouting comment=\
    "MARK CONNECTION INPUT ISP1" in-interface=sfp1 new-connection-mark=ISP1 \
    passthrough=yes
add action=mark-connection chain=prerouting comment=\
    "MARK CONNECTION INPUT ISP2-LTE " in-interface=lte1 new-connection-mark=\
    ISP2-LTE passthrough=yes
add action=mark-connection chain=postrouting comment=\
    "MARK CONNECTION OUT ISP1" new-connection-mark=ISP1 out-interface=sfp1 \
    passthrough=yes
add action=mark-connection chain=postrouting comment=\
    "MARK CONNECTION OUT ISP2-LTE" new-connection-mark=ISP2-LTE \
    out-interface=lte1 passthrough=yes
add action=jump chain=prerouting comment="MARK ALL INPUT CONNECTION" \
    jump-target=prerouting-mark-route
add action=return chain=prerouting-mark-route comment="NO MARK  ISP1" \
    in-interface=sfp1
add action=return chain=prerouting-mark-route comment="NO MARK ISP2-LTE" \
    in-interface=lte1
add action=jump chain=prerouting-mark-route comment=\
    "MARK ROUTE (MARSHRUTIZACI)" jump-target=mark-route
add action=mark-routing chain=mark-route comment=\
    "IF CONNECTION MARK ISP1 TO ROUTISP1" connection-mark=ISP1 \
    new-routing-mark=RoutISP1 passthrough=yes
add action=mark-routing chain=mark-route comment=\
    "IF CONNECTION MARK ISP2-LTE TO ROUTISP2-LTE" connection-mark=ISP2-LTE \
    new-routing-mark=RoutISP2-LTE passthrough=yes
add action=jump chain=output comment="MARK OUT CONNECTION MIKROTIK" \
    jump-target=mark-route
	
/ip route
add distance=1 gateway=1.1.1.1 routing-mark=RoutISP1
add distance=2 gateway=2.2.2.2 routing-mark=RoutISP2-LTE
