MIL_3_Tfile_Hdr_ 145A 140A modeler 9 66A71D0C 66C2CCD4 16 ray-laptop 28918 0 0 none none 0 0 none B8B16BF7 1BD1 0 0 0 0 0 0 1bcc 1                                                                                                                                                                                                                                                                                                                                                                                              ЋЭg      @   D   H      г  ­  Б  Е  Й  Х  Щ  Э  Ч           	   begsim intrpt         
   џџџџ   
   doc file            	nd_module      endsim intrpt             џџџџ      failure intrpts            disabled      intrpt interval         дВI­%У}џџџџ      priority              џџџџ      recovery intrpts            disabled      subqueue                     count    џџџ   
   џџџџ   
      list   	џџџ   
          
      super priority             џџџџ             /* my node address */   int	\my_address;       Objid	\my_id;       Objid	\my_node_id;       /* rcv pk type */   
int	\type;       int	\interactive_id;       '/* the next hop to the interact node */   int	\to_interact_next_hop;       /* the Num of the pk */   int	\interact_pk_num;       /* 0 or 1 for the net topo */   int	\topo[24][24];       #/* pk num of interact collection */   int	\link_interact_pk_num;       /* time out self intrpt */   Evhandle	\evh;          Packet* pkptr;   
int i,j,z;      #include <math.h>       /* Constant Definitions */       #define SRC_IN		(1)   #define SINK_OUT	(1)   #define TX_OUT		(2)   #define RX_IN		(2)               "/* Transition Condition Macros */    Z#define FROM_RX_PK			(op_intrpt_type() == OPC_INTRPT_STRM) && (op_intrpt_strm () == RX_IN)   \#define FROM_SRC_PK 		(op_intrpt_type() == OPC_INTRPT_STRM) && (op_intrpt_strm () == SRC_IN)                                                      Z   в          
   init   
       
      //initial begin   my_id = op_id_self();   $my_node_id = op_topo_parent (my_id);       6op_ima_obj_attr_get(my_node_id,"Address",&my_address);           for(i=0;i<24;i++)    	for(j=0;j<24;j++) topo[i][j]=0;       .printf("$$$$$$$$$$$$net over$$$$$$$$$$$$$\n");           
                     
   џџџџ   
          pr_state           в          
   idle   
                                       џџџџ             pr_state        J   Z          
   rx_rcv   
       J   l   int a_topo[276];   int num_elements=9;   int int_array[9];   unsigned char bit_sequence[35];       //ЪеЕНВЛЭЌРраЭАќЕФааЮЊ   "pkptr=op_pk_get(op_intrpt_strm());   %op_pk_nfd_get (pkptr, "TYPE", &type);       if(type==0x14)//cross_request   	{   4	op_pk_nfd_get(pkptr,"Interact_ID",&interactive_id);   	z=0;   	for(i=0;i<23;i++)   		{   		for(j=i+1;j<24;j++)   			{   2			if(topo[i][j]==1 || topo[j][i]==1) a_topo[z]=1;   			else a_topo[z]=0;   			z++;   			}   		}   	for(i=0;i<276;i++)   		{   		if(a_topo[i]==1)   )			bit_sequence[i / 8] |= (1 << (i % 8));   		else   *			bit_sequence[i / 8] &= ~(1 << (i % 8));   		}   	for(i=0;i<num_elements;i++)   		{   		int_array[i]=0;   		for(j=0;j<4;j++)   =			int_array[i] |= (bit_sequence[i * 4 + j] << (8 * (3- j)));   		}       /	op_pk_nfd_set(pkptr,"Net_Topo1",int_array[0]);   /	op_pk_nfd_set(pkptr,"Net_Topo2",int_array[1]);   /	op_pk_nfd_set(pkptr,"Net_Topo3",int_array[2]);   /	op_pk_nfd_set(pkptr,"Net_Topo4",int_array[3]);   /	op_pk_nfd_set(pkptr,"Net_Topo5",int_array[4]);   /	op_pk_nfd_set(pkptr,"Net_Topo6",int_array[5]);   /	op_pk_nfd_set(pkptr,"Net_Topo7",int_array[6]);   /	op_pk_nfd_set(pkptr,"Net_Topo8",int_array[7]);   /	op_pk_nfd_set(pkptr,"Net_Topo9",int_array[8]);       	op_pk_send(pkptr,TX_OUT);   	}       if(type==0x13)//link_maintain   	{   	z=0;   0	op_pk_nfd_get(pkptr,"Net_Topo1",&int_array[0]);   0	op_pk_nfd_get(pkptr,"Net_Topo2",&int_array[1]);   0	op_pk_nfd_get(pkptr,"Net_Topo3",&int_array[2]);   0	op_pk_nfd_get(pkptr,"Net_Topo4",&int_array[3]);   0	op_pk_nfd_get(pkptr,"Net_Topo5",&int_array[4]);   0	op_pk_nfd_get(pkptr,"Net_Topo6",&int_array[5]);   0	op_pk_nfd_get(pkptr,"Net_Topo7",&int_array[6]);   0	op_pk_nfd_get(pkptr,"Net_Topo8",&int_array[7]);   0	op_pk_nfd_get(pkptr,"Net_Topo9",&int_array[8]);   "	for(i = 0; i < num_elements; i++)   		for(j = 0; j <4; j++)   D			bit_sequence[i * 4 + j] = (int_array[i] >> (8 * (3 - j))) & 0xFF;   	for (i=0;i<276;i++)   9        a_topo[i] = (bit_sequence[i / 8] >> (i % 8)) & 1;   	//зщжЏtopo   	for(i=0;i<24;i++)   !		for(j=0;j<24;j++) topo[i][j]=0;   	for(i=0;i<23;i++)   		for(j=i+1;j<24;j++)   			{   			topo[i][j]=a_topo[z];   			topo[j][i]=a_topo[z];   			z++;   			}   %	printf("\n ground get the topo:\n");   4	for(i=0;i<24;i++)///////////////////////test for 13   	{   	for(j=0;j<24;j++)   		printf("%d   ",topo[i][j]);   	printf("\n");   	}       +	//ИќаТinteract_id*************************   	//interactive_id==......   	   	   	//cross_request   )	pkptr=op_pk_create_fmt("Cross_request");   (	op_pk_nfd_set(pkptr,"SEND",my_address);   "	op_pk_nfd_set(pkptr,"TYPE",0x14);   3	op_pk_nfd_set(pkptr,"Interact_ID",interactive_id);   /	op_pk_nfd_set(pkptr,"Net_Topo1",int_array[0]);   /	op_pk_nfd_set(pkptr,"Net_Topo2",int_array[1]);   /	op_pk_nfd_set(pkptr,"Net_Topo3",int_array[2]);   /	op_pk_nfd_set(pkptr,"Net_Topo4",int_array[3]);   /	op_pk_nfd_set(pkptr,"Net_Topo5",int_array[4]);   /	op_pk_nfd_set(pkptr,"Net_Topo6",int_array[5]);   /	op_pk_nfd_set(pkptr,"Net_Topo7",int_array[6]);   /	op_pk_nfd_set(pkptr,"Net_Topo8",int_array[7]);   /	op_pk_nfd_set(pkptr,"Net_Topo9",int_array[8]);   	op_pk_send(pkptr,TX_OUT);   	}                   J                     
   џџџџ   
          pr_state        Т            
   src_rcv   
       
       
                     
   џџџџ   
          pr_state                        Б   б      g   Ю   і   б          
   tr_0   
       џџџџ          џџџџ          
    џџџџ   
          џџџџ                       pr_transition               Ю            Ф   Х      §        Р          
   tr_1   
       
   default   
       џџџџ          
    џџџџ   
          џџџџ                       pr_transition              '           М  9   h          
   tr_3   
       
   
FROM_RX_PK   
       џџџџ          
    џџџџ   
          џџџџ                       pr_transition              5        H   j     П          
   tr_5   
       џџџџ          џџџџ          
    џџџџ   
          џџџџ                       pr_transition                 ф        к  Д   џ          
   tr_6   
       
   FROM_SRC_PK   
       џџџџ          
    џџџџ   
          џџџџ                       pr_transition              x   ч     А       р          
   tr_7   
       
џџџџ   
       џџџџ          
    џџџџ   
          џџџџ                       pr_transition                                             