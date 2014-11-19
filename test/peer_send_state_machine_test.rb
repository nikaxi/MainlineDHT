require_relative 'test_helper'
require_relative 'peer_test_helper'
require_relative '../lib/kademlia/peer_send_state_machine'

describe PeerSendStateMachine do

  it "must be able to transition from neutral to wait_unchoke and back" do
    # Initialization is as expected
    test_machine = PeerSendStateMachine.new
    test_machine.neutral?.must_equal true
    test_machine.peer_choking.must_equal true
    test_machine.am_interested.must_equal false

    # Transition from neutral to wait_unchoke
    test_machine.can_send_interested?.must_equal true
    test_machine.send_interested!
    test_machine.wait_unchoke?.must_equal true
    test_machine.peer_choking.must_equal true
    test_machine.am_interested.must_equal true

    # Transition from wait_unchoke to neutral
    test_machine.can_send_not_interested?.must_equal true
    test_machine.send_not_interested!
    test_machine.neutral?.must_equal true
    test_machine.peer_choking.must_equal true
    test_machine.am_interested.must_equal false
  end 

  it "must be able to transition from neutral to wait_unchoke to send to wait_unchoke" do
    # Initialization is as expected
    test_machine = PeerSendStateMachine.new
    test_machine.neutral?.must_equal true
    test_machine.peer_choking.must_equal true
    test_machine.am_interested.must_equal false

    # Transition from neutral to wait_unchoke
    test_machine.can_send_interested?.must_equal true
    test_machine.send_interested!
    test_machine.wait_unchoke?.must_equal true
    test_machine.peer_choking.must_equal true
    test_machine.am_interested.must_equal true

    # Transition from wait_unchoke to send
    test_machine.can_recv_unchoke?.must_equal true 
    test_machine.recv_unchoke!
    test_machine.send?.must_equal true
    test_machine.peer_choking.must_equal false
    test_machine.am_interested.must_equal true

    # Transition from send to wait_unchoke
    test_machine.can_recv_choke?.must_equal true
    test_machine.recv_choke!
    test_machine.wait_unchoke?.must_equal true
    test_machine.peer_choking.must_equal true
    test_machine.am_interested.must_equal true
  end
  
  it "must be able to transition from neutral to wait_unchoke to send to wait_interest to send" do
    # Initialization is as expected
    test_machine = PeerSendStateMachine.new
    test_machine.neutral?.must_equal true
    test_machine.peer_choking.must_equal true
    test_machine.am_interested.must_equal false

    # Transition from neutral to wait_unchoke
    test_machine.can_send_interested?.must_equal true
    test_machine.send_interested!
    test_machine.wait_unchoke?.must_equal true
    test_machine.peer_choking.must_equal true
    test_machine.am_interested.must_equal true

    # Transition from wait_unchoke to send
    test_machine.can_recv_unchoke?.must_equal true 
    test_machine.recv_unchoke!
    test_machine.send?.must_equal true
    test_machine.peer_choking.must_equal false
    test_machine.am_interested.must_equal true

    # Transition from send to wait_interest
    test_machine.can_send_not_interested?.must_equal true
    test_machine.send_not_interested!
    test_machine.wait_interest?.must_equal true
    test_machine.peer_choking.must_equal false
    test_machine.am_interested.must_equal false
    
    # Transition from wait_interest to send 
    test_machine.can_send_interested?.must_equal true
    test_machine.send_interested!
    test_machine.send?.must_equal true
    test_machine.peer_choking.must_equal false
    test_machine.am_interested.must_equal true
  end

  it "must be able to transition from neutral to wait_interest to neutral" do
    # Initialization is as expected
    test_machine = PeerSendStateMachine.new
    test_machine.neutral?.must_equal true
    test_machine.peer_choking.must_equal true
    test_machine.am_interested.must_equal false

    # Transition from neutral to wait_interest
    test_machine.can_recv_unchoke?.must_equal true
    test_machine.recv_unchoke!
    test_machine.wait_interest?.must_equal true
    test_machine.peer_choking.must_equal false
    test_machine.am_interested.must_equal false

    # Transition from wait_interest to neutral
    test_machine.can_recv_choke?.must_equal true
    test_machine.recv_choke!
    test_machine.neutral?.must_equal true
    test_machine.peer_choking.must_equal true
    test_machine.am_interested.must_equal false
  end
end 