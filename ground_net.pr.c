/* Process model C form file: ground_net.pr.c */
/* Portions of this file copyright 1986-2008 by OPNET Technologies, Inc. */



/* This variable carries the header into the object file */
const char ground_net_pr_c [] = "MIL_3_Tfile_Hdr_ 145A 30A op_runsim 7 66C2CCE4 66C2CCE4 1 ray-laptop 28918 0 0 none none 0 0 none 0 0 0 0 0 0 0 0 1bcc 1                                                                                                                                                                                                                                                                                                                                                                                                       ";
#include <string.h>



/* OPNET system definitions */
#include <opnet.h>



/* Header Block */

#include <math.h>

/* Constant Definitions */

#define SRC_IN		(1)
#define SINK_OUT	(1)
#define TX_OUT		(2)
#define RX_IN		(2)



/* Transition Condition Macros */ 
#define FROM_RX_PK			(op_intrpt_type() == OPC_INTRPT_STRM) && (op_intrpt_strm () == RX_IN)
#define FROM_SRC_PK 		(op_intrpt_type() == OPC_INTRPT_STRM) && (op_intrpt_strm () == SRC_IN)



/* End of Header Block */

#if !defined (VOSD_NO_FIN)
#undef	BIN
#undef	BOUT
#define	BIN		FIN_LOCAL_FIELD(_op_last_line_passed) = __LINE__ - _op_block_origin;
#define	BOUT	BIN
#define	BINIT	FIN_LOCAL_FIELD(_op_last_line_passed) = 0; _op_block_origin = __LINE__;
#else
#define	BINIT
#endif /* #if !defined (VOSD_NO_FIN) */



/* State variable definitions */
typedef struct
	{
	/* Internal state tracking for FSM */
	FSM_SYS_STATE
	/* State Variables */
	int	                    		my_address                                      ;	/* my node address */
	Objid	                  		my_id                                           ;
	Objid	                  		my_node_id                                      ;
	int	                    		type                                            ;	/* rcv pk type */
	int	                    		interactive_id                                  ;
	int	                    		to_interact_next_hop                            ;	/* the next hop to the interact node */
	int	                    		interact_pk_num                                 ;	/* the Num of the pk */
	int	                    		topo[24][24]                                    ;	/* 0 or 1 for the net topo */
	int	                    		link_interact_pk_num                            ;	/* pk num of interact collection */
	Evhandle	               		evh                                             ;	/* time out self intrpt */
	} ground_net_state;

#define my_address              		op_sv_ptr->my_address
#define my_id                   		op_sv_ptr->my_id
#define my_node_id              		op_sv_ptr->my_node_id
#define type                    		op_sv_ptr->type
#define interactive_id          		op_sv_ptr->interactive_id
#define to_interact_next_hop    		op_sv_ptr->to_interact_next_hop
#define interact_pk_num         		op_sv_ptr->interact_pk_num
#define topo                    		op_sv_ptr->topo
#define link_interact_pk_num    		op_sv_ptr->link_interact_pk_num
#define evh                     		op_sv_ptr->evh

/* These macro definitions will define a local variable called	*/
/* "op_sv_ptr" in each function containing a FIN statement.	*/
/* This variable points to the state variable data structure,	*/
/* and can be used from a C debugger to display their values.	*/
#undef FIN_PREAMBLE_DEC
#undef FIN_PREAMBLE_CODE
#define FIN_PREAMBLE_DEC	ground_net_state *op_sv_ptr;
#define FIN_PREAMBLE_CODE	\
		op_sv_ptr = ((ground_net_state *)(OP_SIM_CONTEXT_PTR->_op_mod_state_ptr));


/* No Function Block */

#if !defined (VOSD_NO_FIN)
enum { _op_block_origin = __LINE__ };
#endif

/* Undefine optional tracing in FIN/FOUT/FRET */
/* The FSM has its own tracing code and the other */
/* functions should not have any tracing.		  */
#undef FIN_TRACING
#define FIN_TRACING

#undef FOUTRET_TRACING
#define FOUTRET_TRACING

#if defined (__cplusplus)
extern "C" {
#endif
	void ground_net (OP_SIM_CONTEXT_ARG_OPT);
	VosT_Obtype _op_ground_net_init (int * init_block_ptr);
	void _op_ground_net_diag (OP_SIM_CONTEXT_ARG_OPT);
	void _op_ground_net_terminate (OP_SIM_CONTEXT_ARG_OPT);
	VosT_Address _op_ground_net_alloc (VosT_Obtype, int);
	void _op_ground_net_svar (void *, const char *, void **);


#if defined (__cplusplus)
} /* end of 'extern "C"' */
#endif




/* Process model interrupt handling procedure */


void
ground_net (OP_SIM_CONTEXT_ARG_OPT)
	{
#if !defined (VOSD_NO_FIN)
	int _op_block_origin = 0;
#endif
	FIN_MT (ground_net ());

		{
		/* Temporary Variables */
		Packet* pkptr;
		int i,j,z;
		/* End of Temporary Variables */


		FSM_ENTER ("ground_net")

		FSM_BLOCK_SWITCH
			{
			/*---------------------------------------------------------*/
			/** state (init) enter executives **/
			FSM_STATE_ENTER_FORCED_NOLABEL (0, "init", "ground_net [init enter execs]")
				FSM_PROFILE_SECTION_IN ("ground_net [init enter execs]", state0_enter_exec)
				{
				//initial begin
				my_id = op_id_self();
				my_node_id = op_topo_parent (my_id);
				
				op_ima_obj_attr_get(my_node_id,"Address",&my_address);
				
				
				for(i=0;i<24;i++)
					for(j=0;j<24;j++) topo[i][j]=0;
				
				printf("$$$$$$$$$$$$net over$$$$$$$$$$$$$\n");
				
				
				}
				FSM_PROFILE_SECTION_OUT (state0_enter_exec)

			/** state (init) exit executives **/
			FSM_STATE_EXIT_FORCED (0, "init", "ground_net [init exit execs]")


			/** state (init) transition processing **/
			FSM_TRANSIT_FORCE (1, state1_enter_exec, ;, "default", "", "init", "idle", "tr_0", "ground_net [init -> idle : default / ]")
				/*---------------------------------------------------------*/



			/** state (idle) enter executives **/
			FSM_STATE_ENTER_UNFORCED (1, "idle", state1_enter_exec, "ground_net [idle enter execs]")

			/** blocking after enter executives of unforced state. **/
			FSM_EXIT (3,"ground_net")


			/** state (idle) exit executives **/
			FSM_STATE_EXIT_UNFORCED (1, "idle", "ground_net [idle exit execs]")


			/** state (idle) transition processing **/
			FSM_PROFILE_SECTION_IN ("ground_net [idle trans conditions]", state1_trans_conds)
			FSM_INIT_COND (FROM_RX_PK)
			FSM_TEST_COND (FROM_SRC_PK)
			FSM_DFLT_COND
			FSM_TEST_LOGIC ("idle")
			FSM_PROFILE_SECTION_OUT (state1_trans_conds)

			FSM_TRANSIT_SWITCH
				{
				FSM_CASE_TRANSIT (0, 2, state2_enter_exec, ;, "FROM_RX_PK", "", "idle", "rx_rcv", "tr_3", "ground_net [idle -> rx_rcv : FROM_RX_PK / ]")
				FSM_CASE_TRANSIT (1, 3, state3_enter_exec, ;, "FROM_SRC_PK", "", "idle", "src_rcv", "tr_6", "ground_net [idle -> src_rcv : FROM_SRC_PK / ]")
				FSM_CASE_TRANSIT (2, 1, state1_enter_exec, ;, "default", "", "idle", "idle", "tr_1", "ground_net [idle -> idle : default / ]")
				}
				/*---------------------------------------------------------*/



			/** state (rx_rcv) enter executives **/
			FSM_STATE_ENTER_FORCED (2, "rx_rcv", state2_enter_exec, "ground_net [rx_rcv enter execs]")
				FSM_PROFILE_SECTION_IN ("ground_net [rx_rcv enter execs]", state2_enter_exec)
				{
				int a_topo[276];
				int num_elements=9;
				int int_array[9];
				unsigned char bit_sequence[35];
				
				//收到不同类型包的行为
				pkptr=op_pk_get(op_intrpt_strm());
				op_pk_nfd_get (pkptr, "TYPE", &type);
				
				if(type==0x14)//cross_request
					{
					op_pk_nfd_get(pkptr,"Interact_ID",&interactive_id);
					z=0;
					for(i=0;i<23;i++)
						{
						for(j=i+1;j<24;j++)
							{
							if(topo[i][j]==1 || topo[j][i]==1) a_topo[z]=1;
							else a_topo[z]=0;
							z++;
							}
						}
					for(i=0;i<276;i++)
						{
						if(a_topo[i]==1)
							bit_sequence[i / 8] |= (1 << (i % 8));
						else
							bit_sequence[i / 8] &= ~(1 << (i % 8));
						}
					for(i=0;i<num_elements;i++)
						{
						int_array[i]=0;
						for(j=0;j<4;j++)
							int_array[i] |= (bit_sequence[i * 4 + j] << (8 * (3- j)));
						}
				
					op_pk_nfd_set(pkptr,"Net_Topo1",int_array[0]);
					op_pk_nfd_set(pkptr,"Net_Topo2",int_array[1]);
					op_pk_nfd_set(pkptr,"Net_Topo3",int_array[2]);
					op_pk_nfd_set(pkptr,"Net_Topo4",int_array[3]);
					op_pk_nfd_set(pkptr,"Net_Topo5",int_array[4]);
					op_pk_nfd_set(pkptr,"Net_Topo6",int_array[5]);
					op_pk_nfd_set(pkptr,"Net_Topo7",int_array[6]);
					op_pk_nfd_set(pkptr,"Net_Topo8",int_array[7]);
					op_pk_nfd_set(pkptr,"Net_Topo9",int_array[8]);
				
					op_pk_send(pkptr,TX_OUT);
					}
				
				if(type==0x13)//link_maintain
					{
					z=0;
					op_pk_nfd_get(pkptr,"Net_Topo1",&int_array[0]);
					op_pk_nfd_get(pkptr,"Net_Topo2",&int_array[1]);
					op_pk_nfd_get(pkptr,"Net_Topo3",&int_array[2]);
					op_pk_nfd_get(pkptr,"Net_Topo4",&int_array[3]);
					op_pk_nfd_get(pkptr,"Net_Topo5",&int_array[4]);
					op_pk_nfd_get(pkptr,"Net_Topo6",&int_array[5]);
					op_pk_nfd_get(pkptr,"Net_Topo7",&int_array[6]);
					op_pk_nfd_get(pkptr,"Net_Topo8",&int_array[7]);
					op_pk_nfd_get(pkptr,"Net_Topo9",&int_array[8]);
					for(i = 0; i < num_elements; i++)
						for(j = 0; j <4; j++)
							bit_sequence[i * 4 + j] = (int_array[i] >> (8 * (3 - j))) & 0xFF;
					for (i=0;i<276;i++)
				        a_topo[i] = (bit_sequence[i / 8] >> (i % 8)) & 1;
					//组织topo
					for(i=0;i<24;i++)
						for(j=0;j<24;j++) topo[i][j]=0;
					for(i=0;i<23;i++)
						for(j=i+1;j<24;j++)
							{
							topo[i][j]=a_topo[z];
							topo[j][i]=a_topo[z];
							z++;
							}
					printf("\n ground get the topo:\n");
					for(i=0;i<24;i++)///////////////////////test for 13
					{
					for(j=0;j<24;j++)
						printf("%d   ",topo[i][j]);
					printf("\n");
					}
				
					//更新interact_id*************************
					//interactive_id==......
					
					
					//cross_request
					pkptr=op_pk_create_fmt("Cross_request");
					op_pk_nfd_set(pkptr,"SEND",my_address);
					op_pk_nfd_set(pkptr,"TYPE",0x14);
					op_pk_nfd_set(pkptr,"Interact_ID",interactive_id);
					op_pk_nfd_set(pkptr,"Net_Topo1",int_array[0]);
					op_pk_nfd_set(pkptr,"Net_Topo2",int_array[1]);
					op_pk_nfd_set(pkptr,"Net_Topo3",int_array[2]);
					op_pk_nfd_set(pkptr,"Net_Topo4",int_array[3]);
					op_pk_nfd_set(pkptr,"Net_Topo5",int_array[4]);
					op_pk_nfd_set(pkptr,"Net_Topo6",int_array[5]);
					op_pk_nfd_set(pkptr,"Net_Topo7",int_array[6]);
					op_pk_nfd_set(pkptr,"Net_Topo8",int_array[7]);
					op_pk_nfd_set(pkptr,"Net_Topo9",int_array[8]);
					op_pk_send(pkptr,TX_OUT);
					}
				
				
				
				
				}
				FSM_PROFILE_SECTION_OUT (state2_enter_exec)

			/** state (rx_rcv) exit executives **/
			FSM_STATE_EXIT_FORCED (2, "rx_rcv", "ground_net [rx_rcv exit execs]")


			/** state (rx_rcv) transition processing **/
			FSM_TRANSIT_FORCE (1, state1_enter_exec, ;, "default", "", "rx_rcv", "idle", "tr_5", "ground_net [rx_rcv -> idle : default / ]")
				/*---------------------------------------------------------*/



			/** state (src_rcv) enter executives **/
			FSM_STATE_ENTER_FORCED (3, "src_rcv", state3_enter_exec, "ground_net [src_rcv enter execs]")

			/** state (src_rcv) exit executives **/
			FSM_STATE_EXIT_FORCED (3, "src_rcv", "ground_net [src_rcv exit execs]")


			/** state (src_rcv) transition processing **/
			FSM_TRANSIT_FORCE (1, state1_enter_exec, ;, "default", "", "src_rcv", "idle", "tr_7", "ground_net [src_rcv -> idle : default / ]")
				/*---------------------------------------------------------*/



			}


		FSM_EXIT (0,"ground_net")
		}
	}




void
_op_ground_net_diag (OP_SIM_CONTEXT_ARG_OPT)
	{
	/* No Diagnostic Block */
	}




void
_op_ground_net_terminate (OP_SIM_CONTEXT_ARG_OPT)
	{

	FIN_MT (_op_ground_net_terminate ())


	/* No Termination Block */

	Vos_Poolmem_Dealloc (op_sv_ptr);

	FOUT
	}


/* Undefine shortcuts to state variables to avoid */
/* syntax error in direct access to fields of */
/* local variable prs_ptr in _op_ground_net_svar function. */
#undef my_address
#undef my_id
#undef my_node_id
#undef type
#undef interactive_id
#undef to_interact_next_hop
#undef interact_pk_num
#undef topo
#undef link_interact_pk_num
#undef evh

#undef FIN_PREAMBLE_DEC
#undef FIN_PREAMBLE_CODE

#define FIN_PREAMBLE_DEC
#define FIN_PREAMBLE_CODE

VosT_Obtype
_op_ground_net_init (int * init_block_ptr)
	{
	VosT_Obtype obtype = OPC_NIL;
	FIN_MT (_op_ground_net_init (init_block_ptr))

	obtype = Vos_Define_Object_Prstate ("proc state vars (ground_net)",
		sizeof (ground_net_state));
	*init_block_ptr = 0;

	FRET (obtype)
	}

VosT_Address
_op_ground_net_alloc (VosT_Obtype obtype, int init_block)
	{
#if !defined (VOSD_NO_FIN)
	int _op_block_origin = 0;
#endif
	ground_net_state * ptr;
	FIN_MT (_op_ground_net_alloc (obtype))

	ptr = (ground_net_state *)Vos_Alloc_Object (obtype);
	if (ptr != OPC_NIL)
		{
		ptr->_op_current_block = init_block;
#if defined (OPD_ALLOW_ODB)
		ptr->_op_current_state = "ground_net [init enter execs]";
#endif
		}
	FRET ((VosT_Address)ptr)
	}



void
_op_ground_net_svar (void * gen_ptr, const char * var_name, void ** var_p_ptr)
	{
	ground_net_state		*prs_ptr;

	FIN_MT (_op_ground_net_svar (gen_ptr, var_name, var_p_ptr))

	if (var_name == OPC_NIL)
		{
		*var_p_ptr = (void *)OPC_NIL;
		FOUT
		}
	prs_ptr = (ground_net_state *)gen_ptr;

	if (strcmp ("my_address" , var_name) == 0)
		{
		*var_p_ptr = (void *) (&prs_ptr->my_address);
		FOUT
		}
	if (strcmp ("my_id" , var_name) == 0)
		{
		*var_p_ptr = (void *) (&prs_ptr->my_id);
		FOUT
		}
	if (strcmp ("my_node_id" , var_name) == 0)
		{
		*var_p_ptr = (void *) (&prs_ptr->my_node_id);
		FOUT
		}
	if (strcmp ("type" , var_name) == 0)
		{
		*var_p_ptr = (void *) (&prs_ptr->type);
		FOUT
		}
	if (strcmp ("interactive_id" , var_name) == 0)
		{
		*var_p_ptr = (void *) (&prs_ptr->interactive_id);
		FOUT
		}
	if (strcmp ("to_interact_next_hop" , var_name) == 0)
		{
		*var_p_ptr = (void *) (&prs_ptr->to_interact_next_hop);
		FOUT
		}
	if (strcmp ("interact_pk_num" , var_name) == 0)
		{
		*var_p_ptr = (void *) (&prs_ptr->interact_pk_num);
		FOUT
		}
	if (strcmp ("topo" , var_name) == 0)
		{
		*var_p_ptr = (void *) (prs_ptr->topo);
		FOUT
		}
	if (strcmp ("link_interact_pk_num" , var_name) == 0)
		{
		*var_p_ptr = (void *) (&prs_ptr->link_interact_pk_num);
		FOUT
		}
	if (strcmp ("evh" , var_name) == 0)
		{
		*var_p_ptr = (void *) (&prs_ptr->evh);
		FOUT
		}
	*var_p_ptr = (void *)OPC_NIL;

	FOUT
	}

