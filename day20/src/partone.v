module partone
import os

enum Pulse {
	high
	low
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

pub fn partone(filename string) !int{
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
	// println(nodes)

	mut message_queue := []Message{}
	mut low_counter := 0
	mut high_counter := 0
	for _ in 0..1000{
		// println("New cycle")
		// println(i)
		broadcaster_node := nodes['broadcaster']
		low_counter += 1
		match broadcaster_node{
			BroadCaster{
				for output in broadcaster_node.outputs{
					message_queue << Message{'broadcaster',output,Pulse.low}
				}
			}
			else{
				println("error")
			}
		}
		// println(message_queue)
		// println(low_counter)
		for {
			if message_queue.len == 0{break}
			message := message_queue[0]
			message_queue.delete(0)
			// println(message)
			if message.pulse == Pulse.low{
				low_counter+=1
			}else{
				high_counter+=1
			}
			mut receiver := nodes[message.towards]
			match mut receiver{
				Conjunction{
					receiver.memory[message.from] = message.pulse
					mut is_all_high := true
					for _,value in receiver.memory{
						if(value == Pulse.low){
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
	}

	println(low_counter*high_counter)
	return 0
}