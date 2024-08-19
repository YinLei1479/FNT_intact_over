/* Process model C form file: net_V0.pr.c */
/* Portions of this file copyright 1986-2008 by OPNET Technologies, Inc. */



/* This variable carries the header into the object file */
const char net_V0_pr_c [] = "MIL_3_Tfile_Hdr_ 145A 30A modeler 7 66961888 66961888 1 ray-laptop 28918 0 0 none none 0 0 none 0 0 0 0 0 0 0 0 1bcc 1                                                                                                                                                                                                                                                                                                                                                                                                         ";
#include <string.h>



/* OPNET system definitions */
#include <opnet.h>



/* Header Block */

#include <math.h>

/* Constant Definitions */
#define RX_IN		(0)
#define SRC_IN		(1)
#define TX_OUT		(0)
#define SINK_OUT	(1)



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
	int	                    		my_neighbor[24][2]                              ;	/* neighbor address + neighbor slot */
	int	                    		my_address                                      ;	/* my node address */
	int	                    		nei_count                                       ;	/* number of neighbor */
	                        		                                                	/*                    */
	int	                    		my_slot                                         ;	/* my node slot */
	Objid	                  		my_id                                           ;
	Objid	                  		my_node_id                                      ;
	int	                    		type                                            ;	/* rcv pk type */
	int	                    		my_two_nei_count_sum                            ;	/* two hop neibor number */
	int	                    		my_two_nei[24]                                  ;	/* two hop neighbor address */
	int	                    		now_slot_id[24]                                 ;	/* receive QWZ id in this slot */
	int	                    		now_slot_QWZ_num                                ;
	} net_V0_state;

#define my_neighbor             		op_sv_ptr->my_neighbor
#define my_address              		op_sv_ptr->my_address
#define nei_count               		op_sv_ptr->nei_count
#define my_slot                 		op_sv_ptr->my_slot
#define my_id                   		op_sv_ptr->my_id
#define my_node_id              		op_sv_ptr->my_node_id
#define type                    		op_sv_ptr->type
#define my_two_nei_count_sum    		op_sv_ptr->my_two_nei_count_sum
#define my_two_nei              		op_sv_ptr->my_two_nei
#define now_slot_id             		op_sv_ptr->now_slot_id
#define now_slot_QWZ_num        		op_sv_ptr->now_slot_QWZ_num

/* These macro definitions will define a local variable called	*/
/* "op_sv_ptr" in each function containing a FIN statement.	*/
/* This variable points to the state variable data structure,	*/
/* and can be used from a C debugger to display their values.	*/
#undef FIN_PREAMBLE_DEC
#undef FIN_PREAMBLE_CODE
#define FIN_PREAMBLE_DEC	net_V0_state *op_sv_ptr;
#define FIN_PREAMBLE_CODE	\
		op_sv_ptr = ((net_V0_state *)(OP_SIM_CONTEXT_PTR->_op_mod_state_ptr));


/* Function Block */

#if !defined (VOSD_NO_FIN)
enum { _op_block_origin = __LINE__ + 2};
#endif

/*static void QWZ_rcv(Packet* pkptr)//QWZ_RCV
	{
	int nei_id;
	int nei_slot;
	int nei_in_flag;
	int two_nei_num;
	int two_nei_id[8];
	//int two_nei_in_flag;
	//int count_in;
	int i;
	
	FIN(QWZ_rcv(Packet* pkptr));
	op_pk_nfd_get (pkptr, "Address", &nei_id);
	op_pk_nfd_get (pkptr, "Slot", &nei_slot);
	nei_in_flag=0;
	if(my_neighbor[nei_id][0]==0) nei_count++;
	my_neighbor[nei_id][0]=1;
	my_neighbor[nei_id][1]=nei_slot;
	//完成邻居表与所占用时隙
	
	
	op_pk_nfd_get (pkptr, "Nei_num", &two_nei_num);
	op_pk_nfd_get (pkptr, "Nei_address_0", &two_nei_id[0]);
	op_pk_nfd_get (pkptr, "Nei_address_1", &two_nei_id[1]);
	op_pk_nfd_get (pkptr, "Nei_address_2", &two_nei_id[2]);
	op_pk_nfd_get (pkptr, "Nei_address_3", &two_nei_id[3]);
	op_pk_nfd_get (pkptr, "Nei_address_4", &two_nei_id[4]);
	op_pk_nfd_get (pkptr, "Nei_address_5", &two_nei_id[5]);
	op_pk_nfd_get (pkptr, "Nei_address_6", &two_nei_id[6]);
	op_pk_nfd_get (pkptr, "Nei_address_7", &two_nei_id[7]);
	for(i=0;i<two_nei_num;i++)
		{
		if(my_two_nei[two_nei_id[i]]==0) my_two_nei_count_sum++;
		my_two_nei[two_nei_id[i]]=1;
		}
	//完成两跳邻居节点收集
	
	now_slot_id[nei_id]=1;
	now_slot_QWZ_num++;//收集此帧中QWZ数目与发送QWZ地址
	
	FOUT;
	}
	*/
	
	
		

/* End of Function Block */

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
	void net_V0 (OP_SIM_CONTEXT_ARG_OPT);
	VosT_Obtype _op_net_V0_init (int * init_block_ptr);
	void _op_net_V0_diag (OP_SIM_CONTEXT_ARG_OPT);
	void _op_net_V0_terminate (OP_SIM_CONTEXT_ARG_OPT);
	VosT_Address _op_net_V0_alloc (VosT_Obtype, int);
	void _op_net_V0_svar (void *, const char *, void **);


#if defined (__cplusplus)
} /* end of 'extern "C"' */
#endif




/* Process model interrupt handling procedure */


void
net_V0 (OP_SIM_CONTEXT_ARG_OPT)
	{
#if !defined (VOSD_NO_FIN)
	int _op_block_origin = 0;
#endif
	FIN_MT (net_V0 ());

		{
		/* Temporary Variables */
		int i,j;
		Packet* pkptr;
		int t_c;
		int nei[8];
		
		/* End of Temporary Variables */


		FSM_ENTER ("net_V0")

		FSM_BLOCK_SWITCH
			{
			/*---------------------------------------------------------*/
			/** state (init) enter executives **/
			FSM_STATE_ENTER_FORCED_NOLABEL (0, "init", "net_V0 [init enter execs]")
				FSM_PROFILE_SECTION_IN ("net_V0 [init enter execs]", state0_enter_exec)
				{
				//initial begin
				my_id = op_id_self();
				my_node_id = op_topo_parent (my_id);
				
				op_ima_obj_attr_get(my_node_id,"Address",&my_address);
				
				my_slot = my_address;
				nei_count=0;
				for(i=0;i<24;i++)
					for(j=0;j<2;j++) my_neighbor[i][j]=0xFF;
				my_two_nei_count_sum=0;
				for(i=0;i<24;i++) my_two_nei[i]=0xFF;
				for(i=0;i<24;i++) now_slot_id[i]=0xFF;
				now_slot_QWZ_num=0;
				
				
				printf("$$$$$$$$$$$$net over$$$$$$$$$$$$$\n");
				}
				FSM_PROFILE_SECTION_OUT (state0_enter_exec)

			/** state (init) exit executives **/
			FSM_STATE_EXIT_FORCED (0, "init", "net_V0 [init exit execs]")


			/** state (init) transition processing **/
			FSM_TRANSIT_FORCE (1, state1_enter_exec, ;, "default", "", "init", "idle", "tr_0", "net_V0 [init -> idle : default / ]")
				/*---------------------------------------------------------*/



			/** state (idle) enter executives **/
			FSM_STATE_ENTER_UNFORCED (1, "idle", state1_enter_exec, "net_V0 [idle enter execs]")

			/** blocking after enter executives of unforced state. **/
			FSM_EXIT (3,"net_V0")


			/** state (idle) exit executives **/
			FSM_STATE_EXIT_UNFORCED (1, "idle", "net_V0 [idle exit execs]")


			/** state (idle) transition processing **/
			FSM_PROFILE_SECTION_IN ("net_V0 [idle trans conditions]", state1_trans_conds)
			FSM_INIT_COND (FROM_RX_PK)
			FSM_TEST_COND (FROM_SRC_PK)
			FSM_DFLT_COND
			FSM_TEST_LOGIC ("idle")
			FSM_PROFILE_SECTION_OUT (state1_trans_conds)

			FSM_TRANSIT_SWITCH
				{
				FSM_CASE_TRANSIT (0, 2, state2_enter_exec, ;, "FROM_RX_PK", "", "idle", "rx_rcv", "tr_3", "net_V0 [idle -> rx_rcv : FROM_RX_PK / ]")
				FSM_CASE_TRANSIT (1, 3, state3_enter_exec, ;, "FROM_SRC_PK", "", "idle", "src_rcv", "tr_6", "net_V0 [idle -> src_rcv : FROM_SRC_PK / ]")
				FSM_CASE_TRANSIT (2, 1, state1_enter_exec, ;, "default", "", "idle", "idle", "tr_1", "net_V0 [idle -> idle : default / ]")
				}
				/*---------------------------------------------------------*/



			/** state (rx_rcv) enter executives **/
			FSM_STATE_ENTER_FORCED (2, "rx_rcv", state2_enter_exec, "net_V0 [rx_rcv enter execs]")
				FSM_PROFILE_SECTION_IN ("net_V0 [rx_rcv enter execs]", state2_enter_exec)
				{
				//收到不同类型包的行为
				pkptr=op_pk_get(op_intrpt_strm());
				op_pk_nfd_get (pkptr, "TYPE", &type);
				if(type==0)//QWZ
					{
					//QWZ_rcv(pkptr);
					op_pk_send(pkptr,SINK_OUT);
					}
				}
				FSM_PROFILE_SECTION_OUT (state2_enter_exec)

			/** state (rx_rcv) exit executives **/
			FSM_STATE_EXIT_FORCED (2, "rx_rcv", "net_V0 [rx_rcv exit execs]")


			/** state (rx_rcv) transition processing **/
			FSM_TRANSIT_FORCE (1, state1_enter_exec, ;, "default", "", "rx_rcv", "idle", "tr_5", "net_V0 [rx_rcv -> idle : default / ]")
				/*---------------------------------------------------------*/



			/** state (src_rcv) enter executives **/
			FSM_STATE_ENTER_FORCED (3, "src_rcv", state3_enter_exec, "net_V0 [src_rcv enter execs]")
				FSM_PROFILE_SECTION_IN ("net_V0 [src_rcv enter execs]", state3_enter_exec)
				{
				/*
				pkptr =  op_pk_get (SRC_IN);
				op_pk_nfd_get (pkptr, "TYPE", &type);
				
				if(type==0)//QWZ
					{
					op_pk_nfd_set (pkptr, "Nei_num", nei_count);
					op_pk_nfd_set (pkptr, "Slot", my_slot);
					t_c=0;
					for(i=0;i<24;i++) nei[i]=0xFF;
					for(i=0;i<24;i++)
						{
						if(my_neighbor[i][0]==1)
							{
							nei[t_c]=i;
							t_c++;
							}
						}
					op_pk_nfd_set (pkptr, "Nei_address_0", nei[0]);
					op_pk_nfd_set (pkptr, "Nei_address_1", nei[1]);
					op_pk_nfd_set (pkptr, "Nei_address_2", nei[2]);
					op_pk_nfd_set (pkptr, "Nei_address_3", nei[3]);
					op_pk_nfd_set (pkptr, "Nei_address_4", nei[4]);
					op_pk_nfd_set (pkptr, "Nei_address_5", nei[5]);
					op_pk_nfd_set (pkptr, "Nei_address_6", nei[6]);
					op_pk_nfd_set (pkptr, "Nei_address_7", nei[7]);//装包
					
					op_pk_send(pkptr,TX_OUT);//send to mac
					
					printf("%d	QWZ pk send to mac\n",my_id);
					
					for(i=0;i<24;i++)
						for(j=0;j<2;j++) my_neighbor[i][j]=0xFF;
					nei_count=0;
					my_two_nei_count_sum=0;
					for(i=0;i<24;i++) my_two_nei[i]=0xFF;//一帧清空一次
					}
				*/
				}
				FSM_PROFILE_SECTION_OUT (state3_enter_exec)

			/** state (src_rcv) exit executives **/
			FSM_STATE_EXIT_FORCED (3, "src_rcv", "net_V0 [src_rcv exit execs]")


			/** state (src_rcv) transition processing **/
			FSM_TRANSIT_FORCE (1, state1_enter_exec, ;, "default", "", "src_rcv", "idle", "tr_7", "net_V0 [src_rcv -> idle : default / ]")
				/*---------------------------------------------------------*/



			}


		FSM_EXIT (0,"net_V0")
		}
	}




void
_op_net_V0_diag (OP_SIM_CONTEXT_ARG_OPT)
	{
	/* No Diagnostic Block */
	}




void
_op_net_V0_terminate (OP_SIM_CONTEXT_ARG_OPT)
	{

	FIN_MT (_op_net_V0_terminate ())


	/* No Termination Block */

	Vos_Poolmem_Dealloc (op_sv_ptr);

	FOUT
	}


/* Undefine shortcuts to state variables to avoid */
/* syntax error in direct access to fields of */
/* local variable prs_ptr in _op_net_V0_svar function. */
#undef my_neighbor
#undef my_address
#undef nei_count
#undef my_slot
#undef my_id
#undef my_node_id
#undef type
#undef my_two_nei_count_sum
#undef my_two_nei
#undef now_slot_id
#undef now_slot_QWZ_num

#undef FIN_PREAMBLE_DEC
#undef FIN_PREAMBLE_CODE

#define FIN_PREAMBLE_DEC
#define FIN_PREAMBLE_CODE

VosT_Obtype
_op_net_V0_init (int * init_block_ptr)
	{
	VosT_Obtype obtype = OPC_NIL;
	FIN_MT (_op_net_V0_init (init_block_ptr))

	obtype = Vos_Define_Object_Prstate ("proc state vars (net_V0)",
		sizeof (net_V0_state));
	*init_block_ptr = 0;

	FRET (obtype)
	}

VosT_Address
_op_net_V0_alloc (VosT_Obtype obtype, int init_block)
	{
#if !defined (VOSD_NO_FIN)
	int _op_block_origin = 0;
#endif
	net_V0_state * ptr;
	FIN_MT (_op_net_V0_alloc (obtype))

	ptr = (net_V0_state *)Vos_Alloc_Object (obtype);
	if (ptr != OPC_NIL)
		{
		ptr->_op_current_block = init_block;
#if defined (OPD_ALLOW_ODB)
		ptr->_op_current_state = "net_V0 [init enter execs]";
#endif
		}
	FRET ((VosT_Address)ptr)
	}



void
_op_net_V0_svar (void * gen_ptr, const char * var_name, void ** var_p_ptr)
	{
	net_V0_state		*prs_ptr;

	FIN_MT (_op_net_V0_svar (gen_ptr, var_name, var_p_ptr))

	if (var_name == OPC_NIL)
		{
		*var_p_ptr = (void *)OPC_NIL;
		FOUT
		}
	prs_ptr = (net_V0_state *)gen_ptr;

	if (strcmp ("my_neighbor" , var_name) == 0)
		{
		*var_p_ptr = (void *) (prs_ptr->my_neighbor);
		FOUT
		}
	if (strcmp ("my_address" , var_name) == 0)
		{
		*var_p_ptr = (void *) (&prs_ptr->my_address);
		FOUT
		}
	if (strcmp ("nei_count" , var_name) == 0)
		{
		*var_p_ptr = (void *) (&prs_ptr->nei_count);
		FOUT
		}
	if (strcmp ("my_slot" , var_name) == 0)
		{
		*var_p_ptr = (void *) (&prs_ptr->my_slot);
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
	if (strcmp ("my_two_nei_count_sum" , var_name) == 0)
		{
		*var_p_ptr = (void *) (&prs_ptr->my_two_nei_count_sum);
		FOUT
		}
	if (strcmp ("my_two_nei" , var_name) == 0)
		{
		*var_p_ptr = (void *) (prs_ptr->my_two_nei);
		FOUT
		}
	if (strcmp ("now_slot_id" , var_name) == 0)
		{
		*var_p_ptr = (void *) (prs_ptr->now_slot_id);
		FOUT
		}
	if (strcmp ("now_slot_QWZ_num" , var_name) == 0)
		{
		*var_p_ptr = (void *) (&prs_ptr->now_slot_QWZ_num);
		FOUT
		}
	*var_p_ptr = (void *)OPC_NIL;

	FOUT
	}

