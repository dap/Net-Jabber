
sub testDefined
{
    my ($obj, $tag) = @_;

    my $defined;
    eval "\$defined = \$obj->Defined$tag();";
    is( $defined, 1, lc($tag)." defined" );
}

sub testNotDefined
{
    my ($obj, $tag) = @_;

    my $defined;
    eval "\$defined = \$obj->Defined$tag();";
    is( $defined, '', lc($tag)." not defined" );
}

sub testScalar
{
    my ($obj, $tag, $value) = @_;

    testNotDefined($obj,$tag,'');
    testSetScalar(@_); 
}

sub testSetScalar
{
    my ($obj, $tag, $value) = @_;

    eval "\$obj->Set$tag(\$value);";
    testPostScalar(@_);
}

sub testPostScalar
{
    my ($obj, $tag, $value) = @_;

    testDefined($obj,$tag,1);

    my $get;
    eval "\$get = \$obj->Get$tag();";
    is( $get, $value, lc($tag)." eq '$value'" );
}

sub testFlag
{
    my ($obj, $tag) = @_;

    testNotDefined($obj,$tag,'');

    my $get;
    eval "\$get = \$obj->Get$tag();";
    is( $get, '', lc($tag)." is not set" );
    testSetFlag(@_); 
}

sub testSetFlag
{
    my ($obj, $tag) = @_;

    eval "\$obj->Set$tag();";
    testPostFlag(@_);
}

sub testPostFlag
{
    my ($obj, $tag) = @_;

    testDefined($obj,$tag,1);

    my $get;
    eval "\$get = \$obj->Get$tag();";
    is( $get, 1, lc($tag)." is set" );
}

sub testJID
{
    my ($obj, $tag, $user, $server, $resource) = @_;

    testNotDefined($obj,$tag,'');
    testSetJID(@_);
}

sub testSetJID
{
    my ($obj, $tag, $user, $server, $resource) = @_;

    my $value = $user.'@'.$server.'/'.$resource;

    eval "\$obj->Set$tag(\$value);";
    testPostJID(@_);
}

sub testPostJID
{
    my ($obj, $tag, $user, $server, $resource) = @_;

    my $value = $user.'@'.$server.'/'.$resource;

    testDefined($obj,$tag,1);

    my $get;
    eval "\$get = \$obj->Get$tag();";
    is( $get, $value, lc($tag)." eq '$value'" );

    my $jid;
    eval "\$jid = \$obj->Get$tag(\"jid\");";
    ok( defined($jid), "jid object defined");
    isa_ok( $jid, 'Net::Jabber::JID');
    is( $jid->GetUserID(), $user , "user eq '$user'");
    is( $jid->GetServer(), $server , "server eq '$server'");
    is( $jid->GetResource(), $resource , "resource eq '$resource'");
}

1;
