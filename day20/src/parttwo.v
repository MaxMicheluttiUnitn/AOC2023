module parttwo
import os

fn gcd(a i64,b i64) i64{
	mut m:=a
	mut n:=b
	if m < n {
		mut t:= m
		m = n
		n = t
	}
	for{
		if n == 0{
			break
		}
		r := m % n
		m = n
		n = r
	}
	return m
}

fn lcm(a i64,b i64) i64{
	return (a * b)/gcd(a,b)
}

enum Pulse {
	high
	low
	no_pulse
}

enum Status {
	on
	off
}

struct BroadCaster {
	mut:
	outputs []string
}

struct FlipFlop {
	mut:
	ff_inputs []string
	ff_outputs []string
	status Status
}

struct Conjunction {
	mut:
	conj_inputs []string
	conj_outputs []string
	memory map[string]Pulse
}

struct Message{
	from string
	towards string
	pulse Pulse
}

type Node = BroadCaster | FlipFlop | Conjunction

pub fn parttwo(filename string) !int{
	lines := os.read_lines(filename)! // returned []string with lines (null terminated strings)
	mut nodes := map[string]Node{}
	for line in lines { 
		mut line_items := line.split(" -> ") 
		type_and_name := line_items[0]
		outputs := line_items[1]
		if type_and_name == 'broadcaster'{
			node_name := 'broadcaster'
			mut all_outputs := outputs.split(',')
			for mut output in all_outputs{
				output = output.trim(' ')
			}
			mut new_node := BroadCaster{all_outputs}
			nodes[node_name] = new_node
		}
		else if type_and_name[0] == u8(37){
			node_name := type_and_name.split("%")[1]
			mut all_outputs := outputs.split(',')
			for mut output in all_outputs{
				output = output.trim(' ')
			}
			mut new_node := FlipFlop{[],all_outputs,Status.off}
			nodes[node_name] = new_node
		}else{
			node_name := type_and_name.split("&")[1]
			mut all_outputs := outputs.split(',')
			for mut output in all_outputs{
				output = output.trim(' ')
			}
			mut new_node := Conjunction{[],all_outputs,map[string]Pulse{}}
			nodes[node_name] = new_node
		}
	} 
	for name, mut node in nodes{
		match mut node{
			Conjunction{
				for output in node.conj_outputs{
					mut output_node:=nodes[output]
					match mut output_node{
						Conjunction{
							output_node.conj_inputs << name
						}
						FlipFlop{
							output_node.ff_inputs << name
						}
						else{}
					}
					
				}
			}
			FlipFlop{
				for output in node.ff_outputs{
					mut output_node:=nodes[output]
					match mut output_node{
						Conjunction{
							output_node.conj_inputs << name
						}
						FlipFlop{
							output_node.ff_inputs << name
						}
						else{}
					}
					
				}
			}
			BroadCaster{
				for output in node.outputs{
					mut output_node:=nodes[output]
					match mut output_node{
						Conjunction{
							output_node.conj_inputs << name
						}
						FlipFlop{
							output_node.ff_inputs << name
						}
						else{}
					}
					
				}
			}
		}
	}
	for _, mut node in nodes{
		match mut node{
			Conjunction{
				for input in node.conj_inputs{
					node.memory[input] = Pulse.low
				}
			}
			else{}
		}
	}

	mut submodules_input := []string{};
	broadcaster_node := nodes['broadcaster']
	match broadcaster_node{
		BroadCaster{
			for output in broadcaster_node.outputs{
				submodules_input << output
			}
		}
		else{
			println("error")
		}
	}

	mut loop_lengths := []int{}

	for i in 0..4{
		mut loop_length_of_submodule := 0

		for{
			loop_length_of_submodule += 1
			mut message_queue := []Message{}
			message_queue << Message{'broadcaster',submodules_input[i],Pulse.low}
			mut found_high := false
			for {
				if message_queue.len == 0{break}
				message := message_queue[0]
				message_queue.delete(0)
				// println(message)
				// kl is input for rx
				if message.towards == "kl" && message.pulse==Pulse.high{
					found_high = true
					break
				}

				mut receiver := nodes[message.towards]
				match mut receiver{
					Conjunction{
						receiver.memory[message.from] = message.pulse
						mut is_all_high := true
						for _,value in receiver.memory{
							if value == Pulse.low {
								is_all_high = false
							}
						}
						if is_all_high{
							for output in receiver.conj_outputs{
								message_queue << Message{message.towards,output,Pulse.low}
							}
						}else{
							for output in receiver.conj_outputs{
								message_queue << Message{message.towards,output,Pulse.high}
							}
						}
					}
					FlipFlop{
						if message.pulse == Pulse.low{
							if receiver.status == Status.on{
								receiver.status = Status.off
								for output in receiver.ff_outputs{
									message_queue << Message{message.towards,output,Pulse.low}
								}
							}else{
								receiver.status = Status.on
								for output in receiver.ff_outputs{
									message_queue << Message{message.towards,output,Pulse.high}
								}
							}
						}
					}
					else{}
				}
			}
			if found_high {
				break
			}
			
		}
		loop_lengths << loop_length_of_submodule
		// reset system
		for _, mut node in nodes{
			match mut node{
				Conjunction{
					for input in node.conj_inputs{
						node.memory[input] = Pulse.low
					}
				}
				FlipFlop{
					node.status = Status.off
				}
				else{}
			}
		}
	}
	mut lcm_of_loops := lcm(i64(loop_lengths[0]),i64(loop_lengths[1]))
	for i in 2..4{
		lcm_of_loops = lcm(lcm_of_loops,i64(loop_lengths[i]))	
	}
	println(lcm_of_loops)

	return 0
}