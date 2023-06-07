var( 'phi t mu' )

CGF = phi * ( log( phi )  - log( phi + mu * ( 1 - exp( t ) ) ) )
K = factor( CGF.full_simplify() )
print( "CGF:" )
print( K )
print( "" )

print( "First derivative:" )
dK = factor( derivative( K, t, 1 ).full_simplify() )
print( dK )
print( "" )

print( "First cumulant:" )
k1 = dK.subs(t == 0)
print( k1 )
print( "" )

print( "Second derivative:" )
ddK = factor( derivative( K, t, 2 ).full_simplify() )
print( ddK )
print( "" )

print( "Second cumulant:" )
k2 = ddK.subs(t == 0)
print( k2 )
print( "" )

print( "Third derivative:" )
dddK = factor( derivative( K, t, 3 ).full_simplify() )
print( dddK )
print( "" )

print( "Third cumulant:" )
k3 = dddK.subs(t == 0)
print( k3 )
print( "" )

print( "Fourth derivative:" )
ddddK = factor( derivative( K, t, 4 ).full_simplify() )
print( ddddK )
print( "" )

print( "Fourth cumulant:" )
k4 = ddddK.subs(t == 0)
print( k4 )
print( "" )