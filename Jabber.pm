package Net::Jabber;

=head1 NAME

Net::Jabber - Jabber Perl Library

=head1 SYNOPSIS

  Net::Jabber provides a Perl user with access to the Jabber
  Instant Messaging protocol.

=head1 DESCRIPTION

  Net::Jabber is a convenient tool to use for any perl scripts
  that would like to utilize the Jabber Instant Messaging 
  protocol.  While not a client in and of itself, it provides 
  all of the necessary back-end functions to make a cgi client 
  or command-line perl client feasible and easy to use.  
  Net::Jabber is a wrapper around the rest of the official
  Net::Jabber::xxxxxx packages.  The synopsis above gives an 
  example program that uses these packages to create a vary simple 
  Jabber client that logs a user in and displays any messages
  they receive.

=head1 PACKAGES

  Net::Jabber::Client - this package contains the code needed to
  communicate with a Jabber server: login, wait for messages,
  send messages, and logout.  It uses XML::Stream to read the 
  stream from the server and based on what kind of tag it 
  encounters it calls a function to handle the tag.

  Net::Jabber::Message - everything needed to create and read
  a <message/> received from the server.

  Net::Jabber::Presence - everything needed to create and read
  a <presence/> received from the server.

  Net::Jabber::IQ - IQ is a wrapper around a number of modules
  that provide support for the various namespaces that Jabber
  recognizes.

  Net::Jabber::IQ::Auth - everything needed to authenticate a
  session to the server.

  Net::Jabber::IQ::Info - everything needed to manage and query 
  the personal data sotred on the server.

  Net::Jabber::IQ::Register - everything needed to create a new
  Jabber account on the server.

  Net::Jabber::IQ::Resource - everything needed to manage and
  query Jabber ID Resources.

  Net::Jabber::IQ::Roster - everything needed to manage and query
  the server side Rosters.

=head1 AUTHOR

By Ryan Eatmon in October of 1999 for http://perl.jabber.org/

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.003;
use strict;
use Carp;
use vars qw($VERSION);

$VERSION = "0.8.1";

use Net::Jabber::Message;
($Net::Jabber::Message::VERSION < $Net::Jabber::JABBER_VERSION) &&
  die("Net::Jabber::Message $Net::Jabber::JABBER_VERSION required--this is only version $Net::Jabber::Message::VERSION");

use Net::Jabber::IQ;
($Net::Jabber::IQ::VERSION < $Net::Jabber::JABBER_VERSION) &&
  die("Net::Jabber::IQ $Net::Jabber::JABBER_VERSION required--this is only version $Net::Jabber::IQ::VERSION");

use Net::Jabber::Presence;
($Net::Jabber::Presence::VERSION < $Net::Jabber::JABBER_VERSION) &&
  die("Net::Jabber::Presence $Net::Jabber::JABBER_VERSION required--this is only version $Net::Jabber::Presence::VERSION");

use Net::Jabber::Client;
($Net::Jabber::Client::VERSION < $Net::Jabber::JABBER_VERSION) &&
  die("Net::Jabber::Client $Net::Jabber::JABBER_VERSION required--this is only version $Net::Jabber::Client::VERSION");


##############################################################################
#
# SetXMLData - takes a host of arguments and sets a portion of the specfied
#              XML::Parser::Tree object with that data.  The function works
#              in two modes "single" or "multiple".  "single" denotes that 
#              the function should locate the current tag that matches this 
#              data and overwrite it's contents with data passed in.  
#              "mulitple" denotes that a new tag should be created even if 
#              others exist.
#
#              type    - single or multiple
#              XMLTree - pointer to XML::Parser::Tree
#              tag     - name of tag to create/modify (if blank assumes
#                        working with top level tag)
#              data    - CDATA to set for tag
#              attribs - attributes to ADD to tag
#
##############################################################################
sub SetXMLData {
  my ($type,$XMLTree,$tag,$data,$attribs) = @_;
  my ($key);

  if ($tag ne "") {
    if ($type eq "single") {
      my ($child);
      foreach $child (1..$#{$$XMLTree[1]}) {
	if ($$XMLTree[1]->[$child] eq $tag) {
	  if ($data ne "") {
	    $$XMLTree[1]->[$child+1]->[1] = 0;
	    $$XMLTree[1]->[$child+1]->[2] = $data;
	  }
	  foreach $key (keys(%{$attribs})) {
	    $$XMLTree[1]->[$child+1]->[0]->{$key} = $$attribs{$key};
	  }
	  return;
	}
      }
    }
    $$XMLTree[1]->[($#{$$XMLTree[1]}+1)] = $tag;
    $$XMLTree[1]->[($#{$$XMLTree[1]}+1)]->[0] = {};
    foreach $key (keys(%{$attribs})) {
      $$XMLTree[1]->[$#{$$XMLTree[1]}]->[0]->{$key} = $$attribs{$key};
    }
    $$XMLTree[1]->[$#{$$XMLTree[1]}]->[1] = 0;
    $$XMLTree[1]->[$#{$$XMLTree[1]}]->[2] = $data;
  } else {
    foreach $key (keys(%{$attribs})) {
      $$XMLTree[1]->[0]->{$key} = $$attribs{$key};
    }
  }
}


##############################################################################
#
# GetXMLData - takes a host of arguments and returns various data structures
#              that match them.
#
#              type - "existance" - returns 1 or 0 if the tag exists in the
#                                   top level.
#                     "value" - returns either the CDATA of the tag, or the
#                               value of the attribute depending on which is
#                               sought.  This ignores any markups to the data
#                               and just returns the raw CDATA.
#                     "value array" - returns an array of strings representing
#                                     all of the CDATA in the specified tag.
#                                     This ignores any markups to the data
#                                     and just returns the raw CDATA.
#                     "tree" - returns an XML::Parser::Tree object with the
#                              specified tag as the root tag.
#                     "tree array" - returns an array of XML::Parser::Tree 
#                                    objects each with the specified tag as
#                                    the root tag.
#              XMLTree - pointer to XML::Parser::Tree object
#              tag     - tag to pull data from.  If blank then the top level
#                        tag is accessed.
#              attrib  - attribute value to retrieve.  Ignored for types
#                        "value array", "tree", "tree array".  If paired
#                        with value can be used to filter tags based on
#                        attributes and values.
#              value   - only valid if an attribute is supplied.  Used to
#                        filter for tags that only contain this attribute.
#                        Useful to search through mulitple tags that all
#                        reference different name spaces.
#
##############################################################################
sub GetXMLData {
  my ($type,$XMLTree,$tag,$attrib,$value) = @_;

  if ($tag ne "") {
    my (@array);
    my ($child);
    foreach $child (1..$#{$$XMLTree[1]}) {
      if ($$XMLTree[1]->[$child] eq $tag) {
        #---------------------------------------------------------------------
        # Filter out tags that do not contain the attribute and value.
        #---------------------------------------------------------------------
	next if (($value ne "") && ($attrib ne "") && exists($$XMLTree[1]->[$child+1]->[0]->{$attrib}) && ($$XMLTree[1]->[$child+1]->[0]->{$attrib} ne $value));

        #---------------------------------------------------------------------
	# Check for existance
        #---------------------------------------------------------------------
	if ($type eq "existance") {
	  return 1;
	}
        #---------------------------------------------------------------------
	# Return the raw CDATA value without markups, or the value of the
        # requested attribute.
        #---------------------------------------------------------------------
	if ($type eq "value") {
	  if ($attrib eq "") {
	    my $str = "";
	    my $next = 0;
	    my $index;
	    foreach $index (1..$#{$$XMLTree[1]->[$child+1]}) {
	      if ($next == 1) { $next = 0; next; }
	      if ($$XMLTree[1]->[$child+1]->[$index] eq "0") {
		$str .= $$XMLTree[1]->[$child+1]->[$index+1];
		$next = 1;
	      }
	    }
	    return $str;
	  }
	  return $$XMLTree[1]->[$child+1]->[0]->{$attrib}
	    if (exists $$XMLTree[1]->[$child+1]->[0]->{$attrib});
	}
        #---------------------------------------------------------------------
	# Return an array of values that represent the raw CDATA without
        # markup tags for the requested tags.
        #---------------------------------------------------------------------
	if ($type eq "value array") {
	  my $str = "";
	  my $next = 0;
	  my $index;
	  foreach $index (1..$#{$$XMLTree[1]->[$child+1]}) {
	    if ($next == 1) { $next = 0; next; }
	    if ($$XMLTree[1]->[$child+1]->[$index] eq "0") {
	      $str .= $$XMLTree[1]->[$child+1]->[$index+1];
	      $next = 1;
	    }
	  }
	  push(@array,$str);
	}
        #---------------------------------------------------------------------
	# Return a pointer to a new XML::Parser::Tree object that has the
        # requested tag as the root tag.
        #---------------------------------------------------------------------
	if ($type eq "tree") {
	  my @tree = ( $$XMLTree[1]->[$child] , $$XMLTree[1]->[$child+1] );
	  return @tree;
	}
        #---------------------------------------------------------------------
	# Return an array of pointers to XML::Parser::Tree objects that have
        # the requested tag as the root tags.
        #---------------------------------------------------------------------
	if ($type eq "tree array") {
	  my @tree = ( $$XMLTree[1]->[$child] , $$XMLTree[1]->[$child+1] );
	  push(@array,\@tree);
	}
      }
    }
    #-------------------------------------------------------------------------
    # If we are returning arrays then return array.
    #-------------------------------------------------------------------------
    if (($type eq "tree array") || ($type eq "value array")) {
      return @array;
    }
  } else {
    #
    # NOTE:  This is going to change.  I just realized that I need to handle
    #        the toplevel tag the same os the lower level tags.  Returning
    #        either raw CDATA on a "value" or the entire tree on a "tree".
    #
    return %{$$XMLTree[1]->[0]} if ($attrib eq "");
    return $$XMLTree[1]->[0]->{$attrib} 
      if (exists($$XMLTree[1]->[0]->{$attrib}));
  }
  #---------------------------------------------------------------------------
  # Return 0 if this was a request for existance, or "" if a request for
  # a "value", or [] for "tree", "value array", and "tree array".
  #---------------------------------------------------------------------------
  return 0 if ($type eq "existance");
  return "" if ($type eq "value");
  return [];
}


##############################################################################
#
# EscapeXML - Simple funtion to make sure that no bad characters make it into
#             in the XML string that might cause the string to be 
#             misinterpreted.
#
##############################################################################
sub EscapeXML {
  my $Data = shift;
  $Data =~ s/&/&amp;/g;
  $Data =~ s/</&lt;/g;
  $Data =~ s/>/&gt;/g;
  $Data =~ s/\"/&quot;/g;
  $Data =~ s/\'/&apos;/g;
  return $Data;
}


##############################################################################
#
# BuildXML - takes an XML::Parser::Tree object and builds the XML string that
#            it represents.
#
##############################################################################
sub BuildXML {
  my (@parseTree) = @_;
  my ($str,$att,$child);

  return "" if $#parseTree eq -1;

  if (ref($parseTree[0]) eq "") {

    if ($parseTree[0] eq "0") {
      return &EscapeXML($parseTree[1]);
    }

    $str = "<".$parseTree[0];
    foreach $att (keys(%{$parseTree[1]->[0]})) {
      $str .= " ".$att."='".$parseTree[1]->[0]->{$att}."'";
    }
    
    my $tempStr = &Net::Jabber::BuildXML(@{$parseTree[1]});

    if ($tempStr eq "") {
      $str .= "/>";
    } else {
      $str .= ">";
      $str .= $tempStr;
      $str .= "</".$parseTree[0].">";
    }

  } else {
    shift(@parseTree);
    while("@parseTree" ne "") {
      $str .= &Net::Jabber::BuildXML(@parseTree);
      shift(@parseTree);
      shift(@parseTree);
    }
  }

  return $str;
}


##############################################################################
#
# printData - debugging function to print out any data structure in an 
#             organized manner.  Very useful for debugging XML::Parser::Tree
#             objects.  This is a private function that will only exist in
#             in the development version.
#
##############################################################################
sub printData {
  my ($preString,$data) = @_;

  if (ref($data) eq "HASH") {
    my $key;
    foreach $key (sort { $a cmp $b } keys(%{$data})) {
      if (ref($$data{$key}) eq "") {
	print $preString,"{\'",$key,"\'} = \"",$$data{$key},"\"\n";
      } else {
	print $preString,"{\'",$key,"\'}\n";
	&printData($preString."{'".$key."'}->",$$data{$key});
      }
    }
  }
  if (ref($data) eq "ARRAY") {
    my $index;
    foreach $index (0..$#{$data}) {
      if (ref($$data[$index]) eq "") {
	print $preString,"[",$index,"] = \"",$$data[$index],"\"\n";
      } else {
	print $preString,"[",$index,"]\n";
	&printData($preString."[".$index."]->",$$data[$index]);
      }
    }
  }
  if (ref($data) eq "REF") {
    &printData($preString."->",$$data);
  }
  if (ref($data) eq "") {
    print $preString," = \"",$data,"\"\n";
  }
}



1;

