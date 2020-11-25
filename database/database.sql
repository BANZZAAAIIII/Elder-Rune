PGDMP     7    ;    
        
    x            elru    13.1    13.1 $    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16724    elru    DATABASE     c   CREATE DATABASE elru WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Norwegian_Norway.1252';
    DROP DATABASE elru;
                postgres    false            �            1255    16738    last_updated()    FUNCTION     �   CREATE FUNCTION public.last_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.last_update = CURRENT_TIMESTAMP;
    RETURN NEW;
END
$$;
 %   DROP FUNCTION public.last_updated();
       public          postgres    false            �            1259    16843    enemy    TABLE       CREATE TABLE public.enemy (
    enemy_id integer NOT NULL,
    enemy_name character varying(45) NOT NULL,
    enemy_class integer NOT NULL,
    enemy_health integer NOT NULL,
    enemy_level integer NOT NULL,
    enemy_strength integer NOT NULL,
    enemy_droptable integer NOT NULL
);
    DROP TABLE public.enemy;
       public         heap    postgres    false            �            1259    16821 	   inventory    TABLE     �   CREATE TABLE public.inventory (
    player_id integer NOT NULL,
    item_id integer NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.inventory;
       public         heap    postgres    false            �            1259    16801    items    TABLE       CREATE TABLE public.items (
    item_id integer NOT NULL,
    item_name character varying(45) NOT NULL,
    item_description character varying(200) NOT NULL,
    item_damage integer NOT NULL,
    item_strength integer NOT NULL,
    item_dexterity integer NOT NULL
);
    DROP TABLE public.items;
       public         heap    postgres    false            �            1259    16838    npc    TABLE     �   CREATE TABLE public.npc (
    npc_id integer NOT NULL,
    npc_name character varying(45) NOT NULL,
    npc_class integer NOT NULL
);
    DROP TABLE public.npc;
       public         heap    postgres    false            �            1259    16731    player    TABLE     "  CREATE TABLE public.player (
    player_id integer NOT NULL,
    username character varying(45) NOT NULL,
    email character varying(50) NOT NULL,
    passwordhash character varying(50) NOT NULL,
    player_position point DEFAULT '(0,0)'::point NOT NULL,
    player_xp integer NOT NULL
);
    DROP TABLE public.player;
       public         heap    postgres    false            �            1259    16760    player_skills    TABLE     �   CREATE TABLE public.player_skills (
    player_id integer NOT NULL,
    skill_id integer NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);
 !   DROP TABLE public.player_skills;
       public         heap    postgres    false            �            1259    16735    skills    TABLE     �   CREATE TABLE public.skills (
    skill_id integer NOT NULL,
    skill_name character varying(45) NOT NULL,
    required_xp integer NOT NULL
);
    DROP TABLE public.skills;
       public         heap    postgres    false            �            1259    16789    ui    TABLE     �   CREATE TABLE public.ui (
    player_id integer NOT NULL,
    ui_nameplate smallint DEFAULT '1'::smallint NOT NULL,
    ui_map smallint DEFAULT '1'::smallint NOT NULL,
    last_update timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.ui;
       public         heap    postgres    false            �          0    16843    enemy 
   TABLE DATA           ~   COPY public.enemy (enemy_id, enemy_name, enemy_class, enemy_health, enemy_level, enemy_strength, enemy_droptable) FROM stdin;
    public          postgres    false    207   �+       �          0    16821 	   inventory 
   TABLE DATA           D   COPY public.inventory (player_id, item_id, last_update) FROM stdin;
    public          postgres    false    205   �+       �          0    16801    items 
   TABLE DATA           q   COPY public.items (item_id, item_name, item_description, item_damage, item_strength, item_dexterity) FROM stdin;
    public          postgres    false    204   �+       �          0    16838    npc 
   TABLE DATA           :   COPY public.npc (npc_id, npc_name, npc_class) FROM stdin;
    public          postgres    false    206   ,       �          0    16731    player 
   TABLE DATA           f   COPY public.player (player_id, username, email, passwordhash, player_position, player_xp) FROM stdin;
    public          postgres    false    200   ,       �          0    16760    player_skills 
   TABLE DATA           I   COPY public.player_skills (player_id, skill_id, last_update) FROM stdin;
    public          postgres    false    202   <,       �          0    16735    skills 
   TABLE DATA           C   COPY public.skills (skill_id, skill_name, required_xp) FROM stdin;
    public          postgres    false    201   Y,       �          0    16789    ui 
   TABLE DATA           J   COPY public.ui (player_id, ui_nameplate, ui_map, last_update) FROM stdin;
    public          postgres    false    203   v,       P           2606    16847    enemy enemy_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.enemy
    ADD CONSTRAINT enemy_pkey PRIMARY KEY (enemy_id);
 :   ALTER TABLE ONLY public.enemy DROP CONSTRAINT enemy_pkey;
       public            postgres    false    207            L           2606    16826    inventory inventory_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (player_id, item_id);
 B   ALTER TABLE ONLY public.inventory DROP CONSTRAINT inventory_pkey;
       public            postgres    false    205    205            J           2606    16805    items items_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (item_id);
 :   ALTER TABLE ONLY public.items DROP CONSTRAINT items_pkey;
       public            postgres    false    204            N           2606    16842    npc npc_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.npc
    ADD CONSTRAINT npc_pkey PRIMARY KEY (npc_id);
 6   ALTER TABLE ONLY public.npc DROP CONSTRAINT npc_pkey;
       public            postgres    false    206            D           2606    16746    player player_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.player
    ADD CONSTRAINT player_pkey PRIMARY KEY (player_id);
 <   ALTER TABLE ONLY public.player DROP CONSTRAINT player_pkey;
       public            postgres    false    200            H           2606    16765     player_skills player_skills_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.player_skills
    ADD CONSTRAINT player_skills_pkey PRIMARY KEY (player_id, skill_id);
 J   ALTER TABLE ONLY public.player_skills DROP CONSTRAINT player_skills_pkey;
       public            postgres    false    202    202            F           2606    16759    skills skills_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (skill_id);
 <   ALTER TABLE ONLY public.skills DROP CONSTRAINT skills_pkey;
       public            postgres    false    201            X           2620    16837    inventory last_updated    TRIGGER     s   CREATE TRIGGER last_updated BEFORE UPDATE ON public.inventory FOR EACH ROW EXECUTE FUNCTION public.last_updated();
 /   DROP TRIGGER last_updated ON public.inventory;
       public          postgres    false    205    208            V           2620    16776    player_skills last_updated    TRIGGER     w   CREATE TRIGGER last_updated BEFORE UPDATE ON public.player_skills FOR EACH ROW EXECUTE FUNCTION public.last_updated();
 3   DROP TRIGGER last_updated ON public.player_skills;
       public          postgres    false    202    208            W           2620    16800    ui last_updated    TRIGGER     l   CREATE TRIGGER last_updated BEFORE UPDATE ON public.ui FOR EACH ROW EXECUTE FUNCTION public.last_updated();
 (   DROP TRIGGER last_updated ON public.ui;
       public          postgres    false    208    203            U           2606    16832     inventory inventory_item_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(item_id) ON UPDATE CASCADE ON DELETE RESTRICT;
 J   ALTER TABLE ONLY public.inventory DROP CONSTRAINT inventory_item_id_fkey;
       public          postgres    false    204    2890    205            T           2606    16827 "   inventory inventory_player_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.player(player_id) ON UPDATE CASCADE ON DELETE RESTRICT;
 L   ALTER TABLE ONLY public.inventory DROP CONSTRAINT inventory_player_id_fkey;
       public          postgres    false    205    2884    200            Q           2606    16766 )   player_skills player_skill_player_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.player_skills
    ADD CONSTRAINT player_skill_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.player(player_id) ON UPDATE CASCADE ON DELETE RESTRICT;
 S   ALTER TABLE ONLY public.player_skills DROP CONSTRAINT player_skill_player_id_fkey;
       public          postgres    false    200    2884    202            R           2606    16771 (   player_skills player_skill_skill_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.player_skills
    ADD CONSTRAINT player_skill_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(skill_id) ON UPDATE CASCADE ON DELETE RESTRICT;
 R   ALTER TABLE ONLY public.player_skills DROP CONSTRAINT player_skill_skill_id_fkey;
       public          postgres    false    2886    201    202            S           2606    16795    ui ui_player_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ui
    ADD CONSTRAINT ui_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.player(player_id) ON UPDATE CASCADE ON DELETE RESTRICT;
 >   ALTER TABLE ONLY public.ui DROP CONSTRAINT ui_player_id_fkey;
       public          postgres    false    2884    200    203            �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �     