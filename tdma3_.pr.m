MIL_3_Tfile_Hdr_ 145A 140A modeler 9 66A366DA 66A366DA 1 ray-laptop 28918 0 0 none none 0 0 none CB6C3B12 734A 0 0 0 0 0 0 1bcc 1                                                                                                                                                                                                                                                                                                                                                                                               ��g�      @   D   �  �  �  3  f�  f�  k�  q-  q9  qB  qF  '          Slot Length   �������      seconds       ?�      ����              ����              ����           �Z             	   begsim intrpt         
   ����   
   doc file            	nd_module      endsim intrpt             ����      failure intrpts            disabled      intrpt interval         ԲI�%��}����      priority              ����      recovery intrpts            disabled      subqueue                     count    ���   
   ����   
      list   	���   
          
      super priority             ����          k   int	\my_offset;       double	\slot_length;       double	\tx_data_rate;       int	\intrpt_flag;       int	\num_pk_sent;       int	\num_pk_rcvd;       int	\num_bits_sent;       int	\num_bits_rcvd;       Stathandle	\num_pk_sent_stat;        Stathandle	\global_pk_sent_stat;       Stathandle	\num_pk_rcvd_stat;        Stathandle	\global_pk_rcvd_stat;       Objid	\my_node_id;       Objid	\my_id;       Stathandle	\num_bits_sent_stat;       "Stathandle	\global_bits_sent_stat;       Stathandle	\num_bits_rcvd_stat;       "Stathandle	\global_bits_rcvd_stat;       Stathandle	\bits_sec_rcvd_stat;       Stathandle	\bits_sec_sent_stat;       Stathandle	\pk_sec_rcvd_stat;       Stathandle	\pk_sec_sent_stat;       &Stathandle	\global_bits_sec_rcvd_stat;       &Stathandle	\global_bits_sec_sent_stat;       $Stathandle	\global_pk_sec_rcvd_stat;       $Stathandle	\global_pk_sec_sent_stat;       int	\my_address;       
int	\type;       /* neighbor address */   int	\my_neighbor[24];       /* number of neighbor */   int	\nei_count;       /* two hop neighbor number */   int	\my_two_nei_count_sum;       /* two hop neighbor address */   int	\my_two_nei[24];       /* 0 or 1 for is my slot ? */   int	\is_my_slot;       int	\my_slot_end;       /* interactive node address */   int	\interactive_id;       /* initiai wait self intrpt */   Evhandle	\evh1;       /* need still to wait */   
int	\WAIT;       /* all slot number */   int	\num_slots;       int	\my_net_id;       int	\my_node_state;       int	\my_clock_level;       A/* record in a frame                                           */   A/* node_id + nei_offset + net_id + CL + Location + have_intact */   int	\a_frame_record[8][6];       int	\a_frame_num;       int	\my_have_intact;       /* interact intrpt is coming */   int	\INTACT_FLAG;       /* neighbor in last frame */   int	\my_before_neighbor[8];       int	\my_before_frame_num;          Packet*	pkptr;       !Objid 	tx_id, comp_id, tx_ch_id;        //double  floor();   //double  fmod();       int	used_slots;   int	current_offset;   int	next_offset;           double	current_time;   double	time_left_in_slot;   double	pk_len;   double	pk_time;       double	my_next_slot_time;       int		current_intrpt_type;       int i,j;   int nei_temp[8];   (   #include <math.h>       /* Constant Definitions */   #define RX_IN_STRM		(1)   #define SRC_IN_STRM		(0)   #define TX_OUT_STRM		(1)   #define SINK_OUT_STRM	(0)       7#define EPSILON  		(1e-10)  /* rounding error factor */   #define TDMA_COMPLETE	(-10)   #define FRAME_BEGIN		(2000)   #define INTACT_BEGIN	(4000)               "/* Transition Condition Macros */    U#define NET_BUILD		(op_intrpt_type() == OPC_INTRPT_SELF) && (op_intrpt_code () == 11)   U#define NET_IN			(op_intrpt_type() == OPC_INTRPT_SELF) && (op_intrpt_code () == 1111)   [#define RX_STRM			(op_intrpt_type() == OPC_INTRPT_STRM) && (op_intrpt_strm() == RX_IN_STRM)   _#define FROM_RX			(current_intrpt_type == OPC_INTRPT_STRM) && (op_intrpt_strm () == RX_IN_STRM)   b#define FROM_SRC 		(current_intrpt_type == OPC_INTRPT_STRM) && (op_intrpt_strm () == SRC_IN_STRM)    5#define TRANSMITTING	(op_stat_local_read (0) == 1.0)    T#define SLOT 			(current_intrpt_type == OPC_INTRPT_SELF) && (op_intrpt_code () == 0)   Y#define MY_SLOT 		(current_intrpt_type == OPC_INTRPT_SELF) && (op_intrpt_code () == 3000)   )#define DATA_ENQ 		(!(op_subq_empty (0)))       ,#define	SELF_INTRPT_SCHLD	(intrpt_flag == 1)       /* Global Variables */   int		tdma_pk_sent;   int		tdma_pk_rcvd;   int		tdma_bits_sent;   int		tdma_bits_rcvd;   int		tdma_setup;   int		tdma_id;           static void QWZ_create(void);   #static void QWZ_rcv(Packet* pkptr);   static void net_in(void);   l   'static void QWZ_create(void)//QWZ_CREAT   	{   	int nei_temp[8];   		int i,j;   	Packet* pkptr;   	   	FIN(QWZ_create())   	   	j=0;   	pkptr=op_pk_create_fmt("QWZ");   #	for(i=0;i<8;i++) nei_temp[i]=0xFF;   +	op_pk_nfd_set (pkptr, "SEND", my_address);   "	op_pk_nfd_set (pkptr, "TYPE", 0);   -	op_pk_nfd_set (pkptr, "Nei_num", nei_count);   *	op_pk_nfd_set (pkptr, "Slot", my_offset);   ,	op_pk_nfd_set (pkptr, "Net_id", my_net_id);   4	op_pk_nfd_set (pkptr, "node_state", my_node_state);   6	op_pk_nfd_set (pkptr, "Clock_level", my_clock_level);   	   	for(i=0;i<24;i++)   		{   		if(my_neighbor[i]==1)   			{   			nei_temp[j]=i;   			j++;   			}   		}   5	op_pk_nfd_set (pkptr, "Nei_address_0", nei_temp[0]);   5	op_pk_nfd_set (pkptr, "Nei_address_1", nei_temp[1]);   5	op_pk_nfd_set (pkptr, "Nei_address_2", nei_temp[2]);   5	op_pk_nfd_set (pkptr, "Nei_address_3", nei_temp[3]);   5	op_pk_nfd_set (pkptr, "Nei_address_4", nei_temp[4]);   5	op_pk_nfd_set (pkptr, "Nei_address_5", nei_temp[5]);   5	op_pk_nfd_set (pkptr, "Nei_address_6", nei_temp[6]);   5	op_pk_nfd_set (pkptr, "Nei_address_7", nei_temp[7]);   	   0	//op_subq_pk_insert (0, pkptr, OPC_QPOS_TAIL);    	op_pk_print(pkptr);   	op_pk_send(pkptr,TX_OUT_STRM);   	   	FOUT   	}               +static void QWZ_rcv(Packet* pkptr)//QWZ_RCV   	{   	int nei_id;   	int nei_slot;   	int nei_net_id;   	int nei_CL;   	int two_nei_num;   	int two_nei_id[8];   	int have_intact;   	int i;   	   	FIN(QWZ_rcv(Packet* pkptr))   	   (	op_pk_nfd_get (pkptr, "SEND", &nei_id);   8	op_pk_nfd_get (pkptr, "Slot", &nei_slot);//can caculate   .	op_pk_nfd_get (pkptr, "Net_id", &nei_net_id);   /	op_pk_nfd_get (pkptr, "Clock_level", &nei_CL);   2	op_pk_nfd_get (pkptr,"Have_Intact",&have_intact);   	   		//record   '	a_frame_record[a_frame_num][0]=nei_id;   )	a_frame_record[a_frame_num][1]=nei_slot;   +	a_frame_record[a_frame_num][2]=nei_net_id;   '	a_frame_record[a_frame_num][3]=nei_CL;   ,	a_frame_record[a_frame_num][5]=have_intact;   	a_frame_num++;   				   	//neighbor			   (	if(my_neighbor[nei_id]!=1) nei_count++;   	my_neighbor[nei_id]=1;   0	op_pk_nfd_get (pkptr, "Nei_num", &two_nei_num);   8	op_pk_nfd_get (pkptr, "Nei_address_0", &two_nei_id[0]);   8	op_pk_nfd_get (pkptr, "Nei_address_1", &two_nei_id[1]);   8	op_pk_nfd_get (pkptr, "Nei_address_2", &two_nei_id[2]);   8	op_pk_nfd_get (pkptr, "Nei_address_3", &two_nei_id[3]);   8	op_pk_nfd_get (pkptr, "Nei_address_4", &two_nei_id[4]);   8	op_pk_nfd_get (pkptr, "Nei_address_5", &two_nei_id[5]);   8	op_pk_nfd_get (pkptr, "Nei_address_6", &two_nei_id[6]);   8	op_pk_nfd_get (pkptr, "Nei_address_7", &two_nei_id[7]);   	for(i=0;i<two_nei_num;i++)   		{   :		if(my_two_nei[two_nei_id[i]]==0) my_two_nei_count_sum++;   		my_two_nei[two_nei_id[i]]=1;   		}   	   	//�ڵ�״̬����   	for(i=0;i<two_nei_num;i++)   		{   3		if(two_nei_id[i]==my_address && my_node_state!=1)   			my_node_state=3;   		}   	   	   	FOUT   	}       &static void net_in(void)//�����ڵ�����   	{   	FIN(net_in(void))   	my_node_state=3;   	FOUT   	}   	      Iprintf ("Object ID = %d Current Sim Time = %g\n", my_id, op_sim_time ());   ,printf ("My TDMA Offset = %d\n", my_offset);   2printf ("Number of TDMA Slots = %d\n", num_slots);   :printf ("Number of Packets Received = %d\n", num_pk_rcvd);   9printf ("Number of Bits Received = %d\n", num_bits_rcvd);   6printf ("Number of Packets Sent = %d\n", num_pk_sent);   5printf ("Number of Bits Sent = %d\n", num_bits_sent);                                 	      �   �          
   init   
       
   o   #Distribution * random_integer_dist;   int rn;       6printf("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n");   '/* Get the slot length for all nodes */   Bop_ima_sim_attr_get (OPC_IMA_DOUBLE, "Slot Length", &slot_length);       my_id = op_id_self();   $my_node_id = op_topo_parent (my_id);   my_net_id=0;   my_have_intact=0;   my_before_frame_num=0;       num_slots = 24;   #interactive_id=10;/////////for tset       6op_ima_obj_attr_get(my_node_id,"Address",&my_address);       2/* Initialize tdma offsets if not done previously     if (tdma_setup != TDMA_COMPLETE)   {   	num_slots = 0;   	tdma_setup = TDMA_COMPLETE;   }*/       (/* Calculate the offset for this node */   //num_slots++;   //my_offset = num_slots-1;	       'printf("%d is the offset\n",my_offset);   (/*if (op_prg_odb_ltrace_active ("tdma"))   {   *	printf ("Node Objid = %d\n", my_node_id);   *	printf ("Node Offset = %d\n", my_offset);   	printf ("\n");   }*/   	   C/*Determine the number of various types of nodes in the network */    1/* Determine the data rate for the transmitter */   Itx_id =  op_topo_assoc (my_id, OPC_TOPO_ASSOC_OUT, OPC_OBJTYPE_RATX, 0);    5comp_id = op_topo_child (tx_id, OPC_OBJTYPE_COMP, 0);   :tx_ch_id = op_topo_child (comp_id, OPC_OBJTYPE_RATXCH, 0);   <op_ima_obj_attr_get (tx_ch_id, "data rate", &tx_data_rate);        0/* Initialize statistic calculation variables */       nei_count=0;   a_frame_num=0;   WAIT=0;       for(i=0;i<8;i++)   	{   ,	for(j=0;j<5;j++) a_frame_record[i][j]=0xFF;   	a_frame_record[i][5]=0;   	my_before_neighbor[i]=0xFF;   	}   	       for(i=0;i<24;i++)   	my_neighbor[i]=0;   my_two_nei_count_sum=0;   "for(i=0;i<24;i++) my_two_nei[i]=0;   (//for(i=0;i<24;i++) now_slot_id[i]=0xFF;   //now_slot_QWZ_num=0;       /*   tdma_pk_sent = 0;   tdma_pk_rcvd = 0;   tdma_bits_sent = 0;   tdma_bits_rcvd = 0;   num_pk_sent = 0;   num_pk_rcvd = 0;   num_bits_sent = 0;   num_bits_rcvd = 0;   */       /* Register Statistics */   \num_pk_sent_stat = op_stat_reg ("TDMA.Load (packets)", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   eglobal_pk_sent_stat = op_stat_reg ("TDMA.TDMA Load (packets)", OPC_STAT_INDEX_NONE, OPC_STAT_GLOBAL);   hnum_pk_rcvd_stat = op_stat_reg ("TDMA.Traffic Received (packets)", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   qglobal_pk_rcvd_stat = op_stat_reg ("TDMA.TDMA Traffic Received (packets)", OPC_STAT_INDEX_NONE, OPC_STAT_GLOBAL);       [num_bits_sent_stat = op_stat_reg ("TDMA.Load (bits)", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   dglobal_bits_sent_stat = op_stat_reg ("TDMA.TDMA Load (bits)", OPC_STAT_INDEX_NONE, OPC_STAT_GLOBAL);   gnum_bits_rcvd_stat = op_stat_reg ("TDMA.Traffic Received (bits)", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   pglobal_bits_rcvd_stat = op_stat_reg ("TDMA.TDMA Traffic Received (bits)", OPC_STAT_INDEX_NONE, OPC_STAT_GLOBAL);       kbits_sec_rcvd_stat = op_stat_reg ("TDMA.Traffic Received (bits/sec)", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   _bits_sec_sent_stat = op_stat_reg ("TDMA.Load (bits/sec)", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   lpk_sec_rcvd_stat = op_stat_reg ("TDMA.Traffic Received (packets/sec)", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   `pk_sec_sent_stat = op_stat_reg ("TDMA.Load (packets/sec)", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);       xglobal_bits_sec_rcvd_stat = op_stat_reg ("TDMA.TDMA Traffic Received (bits/sec)", OPC_STAT_INDEX_NONE, OPC_STAT_GLOBAL);   vglobal_pk_sec_rcvd_stat = op_stat_reg ("TDMA.TDMA Traffic Received (bits/sec)", OPC_STAT_INDEX_NONE, OPC_STAT_GLOBAL);   mglobal_pk_sec_sent_stat = op_stat_reg ("TDMA.TDMA Load (packets/sec)", OPC_STAT_INDEX_NONE, OPC_STAT_GLOBAL);   oglobal_bits_sec_sent_stat = op_stat_reg ("TDMA.TDMA Load (packets/sec)", OPC_STAT_INDEX_NONE, OPC_STAT_GLOBAL);                       D/* Schedule interupt to complete initialization in the exit execs */   7printf("%%%%%%%%%%% tdma init is over%%%%%%%%%%%%%\n");               Krandom_integer_dist = op_dist_load("uniform_int",0,96);//�������ʱ�������   )rn =op_dist_outcome(random_integer_dist);   printf("rn::%d\n",rn);       Cevh1=op_intrpt_schedule_self(op_sim_time()+(24+rn)*slot_length,11);   
       
       
       
   ����   
          pr_state      	  :   �          
   idle   
       
       
       
      (current_intrpt_type = op_intrpt_type ();   printf("get the intrpt\n");   
       
    ����   
          pr_state        :   Z          
   fr_rx   
       
   >   int next_hop;   int net_id;   int have_intact;   int clock_level;        pkptr =  op_pk_get (RX_IN_STRM);   %op_pk_nfd_get (pkptr, "TYPE", &type);       if(type==0)//QWZ   	{   	QWZ_rcv(pkptr);   9	printf("%d now has %d neighbor\n",my_address,nei_count);   	op_pk_destroy(pkptr);   	}       (else if(type==6)//�򽻻��ڵ㷢�͵��ϱ�֡   	{   .	op_pk_nfd_get (pkptr, "Next_Hop", &next_hop);   	if(next_hop!=my_address)   		{   		op_pk_destroy(pkptr);   		}   	else   		{   		op_pk_print(pkptr);   "		op_pk_send(pkptr,SINK_OUT_STRM);   		}   	}                   1//pk_len = (double) op_pk_total_size_get (pkptr);       /** Record Statistics **/   ?/** The bits/sec or packets/sec statistics are recorded in		**/   @/** bits and packets, and then the OPNET statistic "capture		**/   =/** mode" is used to obtain a bucketized sum over time.			**/   A/** Record extra 0.0 data-points to enable proper computation	**/   1/** of the "sum/time" based statistics.							**/       (/*op_stat_write (num_pk_rcvd_stat, 1.0);   &op_stat_write (pk_sec_rcvd_stat, 1.0);   &op_stat_write (pk_sec_rcvd_stat, 0.0);       )op_stat_write (global_pk_rcvd_stat, 1.0);   -op_stat_write (global_pk_sec_rcvd_stat, 1.0);   -op_stat_write (global_pk_sec_rcvd_stat, 0.0);       +op_stat_write (num_bits_rcvd_stat, pk_len);   +op_stat_write (bits_sec_rcvd_stat, pk_len);   (op_stat_write (bits_sec_rcvd_stat, 0.0);       .op_stat_write (global_bits_rcvd_stat, pk_len);   2op_stat_write (global_bits_sec_rcvd_stat, pk_len);   1op_stat_write (global_bits_sec_rcvd_stat, 0.0);*/       $//op_pk_send (pkptr, SINK_OUT_STRM);                   
       
       
       
   ����   
          pr_state        �   �          
   fr_src   
       
   )   int source;       !pkptr =  op_pk_get (SRC_IN_STRM);   %op_pk_nfd_get (pkptr, "TYPE", &type);       #if(type==6)//�򽻻��ڵ㷢�͵��ϱ�֡   	{   *	op_pk_nfd_get (pkptr, "Source", &source);   +	if(source==my_address)//���ڵ�֡����䷢��   		{   -		printf("tdma�յ����ڵ�pk,%d\n",my_address);   5		op_pk_nfd_set(pkptr,"Nei_num",my_before_frame_num);   &		/*for(i=0;i<8;i++) nei_temp[i]=0xFF;   		j=0;   		for(i=0;i<24;i++)   			{   			if(my_neighbor[i]==1)   				{   				nei_temp[j]=i;   				j++;   				}   			}*/   @		op_pk_nfd_set (pkptr, "Nei_address_0", my_before_neighbor[0]);   @		op_pk_nfd_set (pkptr, "Nei_address_1", my_before_neighbor[1]);   @		op_pk_nfd_set (pkptr, "Nei_address_2", my_before_neighbor[2]);   @		op_pk_nfd_set (pkptr, "Nei_address_3", my_before_neighbor[3]);   @		op_pk_nfd_set (pkptr, "Nei_address_4", my_before_neighbor[4]);   @		op_pk_nfd_set (pkptr, "Nei_address_5", my_before_neighbor[5]);   @		op_pk_nfd_set (pkptr, "Nei_address_6", my_before_neighbor[6]);   @		op_pk_nfd_set (pkptr, "Nei_address_7", my_before_neighbor[7]);   		///location   		   /		op_subq_pk_insert (0, pkptr, OPC_QPOS_TAIL);    		}   	else//�м̽ڵ�֡��ֱ�ӷ���   		{   .		op_subq_pk_insert (0, pkptr, OPC_QPOS_TAIL);   		}       	}       
       
       
       
   ����   
          pr_state        :  �          
   tx   
       
   Y   int base_id;   int base_net_id;   int NET_CHANGE_FLAG;   is_my_slot=0;   NET_CHANGE_FLAG=0;       ,printf("1111 come tx!!!!!!!!!!!!!!!!!!!\n");   current_time = op_sim_time();   Bused_slots = (int) floor ((current_time / slot_length) + EPSILON);   (current_offset = used_slots % num_slots;       //����ʱ϶�����ɲ�����QWZ    if (current_offset == my_offset)   	{   	//���net_id   	if(my_node_state==3)//�����ڵ�   		{   &		for(i=0;i<a_frame_num;i++)//�õ�����   			{   0			if(a_frame_record[i][2]!=my_net_id)//���Ų�ͬ   				{   k				if(a_frame_record[i][5]==1 || (a_frame_record[i][5]==my_have_intact && my_net_id>a_frame_record[i][2]))   					{   &					base_net_id=a_frame_record[i][2];   					base_id=i;   					NET_CHANGE_FLAG=1;   					break;   					}   				}   			}   "		if(NET_CHANGE_FLAG==1)//��Ҫ����   			{   			//�ҵ�Ŀ��������CL��С��һ��   #			for(i=base_id;i<a_frame_num;i++)   				{   \				if(a_frame_record[i][2]==base_net_id && a_frame_record[i][3]<a_frame_record[base_id][3])   					base_id=i;   				}   			//����������Ϣ   (			my_net_id=a_frame_record[base_id][2];   			my_node_state=2;   /			my_clock_level=a_frame_record[base_id][3]+1;   N			my_offset=my_address-a_frame_record[base_id][0]+a_frame_record[base_id][1];   *			if(my_offset<0) my_offset=my_offset+24;   *			if(my_offset>0) my_offset=my_offset%24;   			}   		}   	   	//����   	QWZ_create();   	is_my_slot=1;       	   	//���ò�����Ϣ   ,	for(i=0;i<8;i++)my_before_neighbor[i]=0xFF;   	for(i=0;i<a_frame_num;i++)   -		my_before_neighbor[i]=a_frame_record[i][0];   !	my_before_frame_num=a_frame_num;   	   	if(INTACT_FLAG==0)   		{   		for(i=0;i<24;i++)   			{   			my_neighbor[i]=0;   			my_two_nei[i]=0;   			}   		nei_count=0;   		my_two_nei_count_sum=0;   		a_frame_num=0;   		for(i=0;i<8;i++)   			{   .			for(j=0;j<5;j++) a_frame_record[i][j]=0xFF;   			a_frame_record[i][5]=0;   			}   		}   	   	}           )next_offset = my_offset - current_offset;   if (next_offset <= 0)   	{   	next_offset += num_slots;   	}   Fmy_next_slot_time = (double) (used_slots + next_offset) * slot_length;           0op_intrpt_schedule_self (my_next_slot_time, 0);        
       
       
       
   ����   
          pr_state        �  �          
   tx_queue   
       
   A   current_time = op_sim_time();   my_slot_end=0;   %/* Determine if currently my slot. */   )/* EPSILON accounts for rounding error */   Bused_slots = (int) floor ((current_time / slot_length) + EPSILON);       jcurrent_offset = used_slots % num_slots;time_left_in_slot = ((used_slots + 1)*slot_length) - current_time;       Opk_len = (double) op_pk_total_size_get (op_subq_pk_access (0, OPC_QPOS_HEAD));    )pk_time = (double) pk_len / tx_data_rate;       @	/* If this is my slot and I have enough time to transmit the */   @	/* entire packet then transmit. Otherwise set a self intrpt  */   @	/* for the beginning of my next slot.                        */   Cif ((current_offset == my_offset) && (pk_time < time_left_in_slot))   	{       %	/* dequeue the packet and send it */   .	pkptr = op_subq_pk_remove (0, OPC_QPOS_HEAD);       2	/* reset the flag to schedule a self interrupt */   2	/* for packets arriving subsequent to this one */   	intrpt_flag = 0;       '	if (op_prg_odb_ltrace_active ("tdma"))   		{   T		printf ("TDMA Node %d is transmitting at time: %f\n", my_node_id, op_sim_time ());   		printf ("\n");   		}   	   0	pk_len = (double) op_pk_total_size_get (pkptr);       		/** Record Statistics **/   A		/** The bits/sec or packets/sec statistics are recorded in		**/   B		/** bits and packets, and then the OPNET statistic "capture		**/   ?		/** mode" is used to obtain a bucketized sum over time.			**/   C		/** Record extra 0.0 data-points to enable proper computation	**/   3		/** of the "sum/time" based statistics.							**/       '	op_stat_write (num_pk_sent_stat, 1.0);   '	op_stat_write (pk_sec_sent_stat, 1.0);   '	op_stat_write (pk_sec_sent_stat, 0.0);       *	op_stat_write (global_pk_sent_stat, 1.0);   .	op_stat_write (global_pk_sec_sent_stat, 1.0);   .	op_stat_write (global_pk_sec_sent_stat, 0.0);       ,	op_stat_write (num_bits_sent_stat, pk_len);   ,	op_stat_write (bits_sec_sent_stat, pk_len);   )	op_stat_write (bits_sec_sent_stat, 0.0);       /	op_stat_write (global_bits_sent_stat, pk_len);   3	op_stat_write (global_bits_sec_sent_stat, pk_len);   0	op_stat_write (global_bits_sec_sent_stat, 0.0);   	   (	printf("zhongzhuan pk coming to tx\n");   	op_pk_print(pkptr);   !	op_pk_send (pkptr, TX_OUT_STRM);       	} /* End if */       else   	{   	my_slot_end=1;   	}   
                     
   ����   
          pr_state           �          
   wait   
                                       ����             pr_state        �   Z          
   RX   
       
   	    pkptr =  op_pk_get (RX_IN_STRM);   %op_pk_nfd_get (pkptr, "TYPE", &type);       if(type==0)//QWZ   	{   	QWZ_rcv(pkptr);   	op_pk_destroy(pkptr);   	WAIT=1;   	}   
                     
   ����   
          pr_state        �   �          
   	net_build   
       
   H   int base_num;   int FF;       FF=0;   //1.����   if(WAIT==0)   	{   	my_net_id=my_address;   	my_node_state=1;   	my_clock_level=0;       	current_time = op_sim_time();   C	used_slots = (int) floor ((current_time / slot_length) + EPSILON);   )	current_offset = used_slots % num_slots;   	my_offset=current_offset;   �	printf(" current_time:%lf\n used_slots:%d\n current_offset:%d\n num_slots:%d\n",current_time,used_slots,current_offset,num_slots);   )	printf("%d::%d\n",my_address,my_offset);       ]	op_intrpt_schedule_self(op_sim_time()+(4*num_slots-1)*slot_length,1111);//��������״̬��ʱ��   	}   
//2.������   else   	{   	base_num=0;   	for(i=0;i<a_frame_num;i++)   		{   		if(a_frame_record[i][5]==1)   			{   			base_num=i;   			FF=1;   				break;   			}   		}   			   	if(FF==1)//���ڽ����ڵ���   		{   #		for(i=base_num;i<a_frame_num;i++)   			{   �			if(a_frame_record[i][2]==a_frame_record[base_num][2] && a_frame_record[i][3]<a_frame_record[base_num][3]) base_num=i;//net_idС��   			}   		}   	else   		{   		for(i=1;i<a_frame_num;i++)   			{   O			if(a_frame_record[i][2]<a_frame_record[base_num][2]) base_num=i;//net_idС��   �			if(a_frame_record[i][2]==a_frame_record[base_num][2] && a_frame_record[i][3]<a_frame_record[base_num][3]) base_num=i;//CLС��   			}   		}   '	my_net_id=a_frame_record[base_num][2];   	my_node_state=2;   .	my_clock_level=a_frame_record[base_num][3]+1;   	//my_offset   N	my_offset=my_address-a_frame_record[base_num][0]+a_frame_record[base_num][1];   (	if(my_offset<0) my_offset=my_offset+24;   )	if(my_offset>24) my_offset=my_offset%24;   �	printf(" current_time:%lf\n used_slots:%d\n current_offset:%d\n num_slots:%d\n",current_time,used_slots,current_offset,num_slots);   )	printf("%d::%d\n",my_address,my_offset);   	   	}       //����ʱ϶���ж�   current_time = op_sim_time();   Bused_slots = (int) floor ((current_time / slot_length) + EPSILON);   (current_offset = used_slots % num_slots;   )next_offset = my_offset - current_offset;   if (next_offset <= 0)   	{   	next_offset += num_slots;   	}   Fmy_next_slot_time = (double) (used_slots + next_offset) * slot_length;   0op_intrpt_schedule_self (my_next_slot_time, 0);    
                     
   ����   
          pr_state               	   	  �   �        �  �   �  �   �      �          
   tr_10   
       
   default   
       
����   
       
    ����   
       
   ����   
                    pr_transition         	        �     (   �  (   o          
   tr_13   
       
   FROM_RX   
       
����   
       
    ����   
       
   ����   
                    pr_transition            	  N   �     N   m  N   �          
   tr_14   
       
����   
       
����   
       
    ����   
       
   ����   
                    pr_transition      #   	     �   �     Q   �  �   �          
   tr_15   
       
   FROM_SRC   
       
����   
       
    ����   
       
   ����   
                    pr_transition      +      	    !     *  n  *   �          
   tr_18   
       
   (!is_my_slot) || (!DATA_ENQ)   
       
����   
       
    ����   
       
   ����   
                    pr_transition      /   	     b  =     G   �  G  l          
   tr_19   
       
   (SLOT)    
       
����   
       
    ����   
       
   ����   
                    pr_transition      =        �  s     )  �  �  �          
   tr_61   
       
   is_my_slot && DATA_ENQ    
       ����          
    ����   
          ����                       pr_transition      >      	  �  9     �  t  �   �  *   �          
   tr_62   
       
   my_slot_end || !DATA_ENQ   
       ����          
    ����   
          ����                       pr_transition      B         �   �      �   �   �   �          
   tr_66   
       ����          ����          
    ����   
          ����                       pr_transition      C           �        �  q   c          
   tr_67   
       
   RX_STRM   
       ����          
    ����   
          ����                       pr_transition      F        K   �        �  z   �          
   tr_70   
       
   	NET_BUILD   
       ����          
    ����   
          ����                       pr_transition      G      	  �   �     �   �  %   �          
   tr_71   
       ����          ����          
    ����   
          ����                       pr_transition      H   	   	  �   �     N   �  �   �  i    D   �          
   tr_72   
       
   NET_IN   
       
   net_in()   
       
    ����   
          ����                       pr_transition      I        H   �     ~   m     �          
   tr_73   
       ����          ����          
    ����   
          ����                       pr_transition      J         �            �   �  #  (  .  (  *     �          
   tr_74   
       
   default   
       ����          
    ����   
          ����                       pr_transition      P      	  �   �     �   �  U   �          
   tr_80   
       
����   
       ����          
    ����   
          ����                       pr_transition      X         �  g     �  t  R  M  H  o  w  z          
   tr_88   
       
   !my_slot_end && DATA_ENQ   
       ����          
    ����   
          ����                       pr_transition         [          Load (bits)          (Number of bits broadcast by this node.          TDMA   bucket/default total/sum   linear        ԲI�%��}   Load (bits/sec)          'Number of bits per second broadcast by    this node.      TDMA   bucket/default total/sum_time   linear        ԲI�%��}   Load (packets)          $Number of packets broadcast by this    node.      TDMA   bucket/default total/sum   linear        ԲI�%��}   Load (packets/sec)          'Number of packets per second broadcast    by this node.      TDMA   bucket/default total/sum_time   linear        ԲI�%��}   Traffic Received (bits)          'Number of bits received by this node.     TDMA   bucket/default total/sum   linear        ԲI�%��}   Traffic Received (bits/sec)          &Number of bits per second received by    this node.      TDMA   bucket/default total/sum_time   linear        ԲI�%��}   Traffic Received (packets)          #Number of packets received by this    node.    TDMA   bucket/default total/sum   linear        ԲI�%��}   Traffic Received (packets/sec)          &Number of packets per second received    by this node.       TDMA   bucket/default total/sum_time   linear        ԲI�%��}      TDMA Load (bits)          &Total number of bits broadcast by all    tdma capable nodes.     TDMA   bucket/default total/sum   linear        ԲI�%��}   TDMA Load (bits/sec)           Total number of bits per second    &broadcast by all tdma capable nodes.     TDMA   bucket/default total/sum_time   linear        ԲI�%��}   TDMA Load (packets)          #Total number of packets per second    %broadcast by all tdma capable nodes.    TDMA   bucket/default total/sum_time   linear        ԲI�%��}   TDMA Load (packets/sec)          #Total number of packets per second    %broadcast by all tdma capable nodes.    TDMA   bucket/default total/sum_time   linear        ԲI�%��}   TDMA Traffic Received (bits)           Total number of bits per second    $received by all tdma capable nodes.    TDMA   bucket/default total/sum_time   linear        ԲI�%��}    TDMA Traffic Received (bits/sec)           Total number of bits per second    $received by all tdma capable nodes.    TDMA   bucket/default total/sum_time   linear        ԲI�%��}   TDMA Traffic Received (packets)          (Total number of packets received by all    tdma capable nodes.    TDMA   bucket/default total/sum   linear        ԲI�%��}   #TDMA Traffic Received (packets/sec)          #Total number of packets per second    $received by all tdma capable nodes.    TDMA   bucket/default total/sum_time   linear        ԲI�%��}                           